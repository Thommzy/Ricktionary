//
//  NetworkUtil.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/28/25.
//

import Foundation

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
}

protocol NetworkUtil {
    var baseUrl: URL { get }
    var headers: [String: String] { get }
}

struct Response<T: Codable, H: Codable> {
    var body: T
    var header: H
}

extension NetworkUtil {
    
    var baseUrl: URL {
        return Environment.baseUrl
    }
    
    var headers: [String: String] {
        var _headers = [String: String]()
        _headers["Accept"] = "*/*"
        _headers["Content-Type"] = "application/json"
        return _headers
    }
    
    func request<T: Codable>(
        url: URL,
        method: HTTPMethod,
        bodyParam: [String: Any]? = nil,
        queryParam: [String: Any]? = nil,
        additionalHeaders: [String: String]? = nil,
        expecting responseType: T.Type,
        authenticate: Bool = true,
        useBasicAuth: Bool = false,
        useDefaultHeaders: Bool = true
    ) async throws -> T {
        var request: URLRequest
        
        if let _queryParam = queryParam {
            var components = URLComponents(string: url.absoluteString)!
            components.queryItems = _queryParam.map({ (arg) -> URLQueryItem in
                let (key, value) = arg
                return URLQueryItem(name: key, value: "\(value)")
            })
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(
                of: "+", with: "%2B"
            )
            request = URLRequest(url: components.url!)
        } else {
            request = URLRequest(url: url)
            
            if let _bodyParam = bodyParam {
                let jsonData = try JSONSerialization.data(
                    withJSONObject: _bodyParam,
                    options: .prettyPrinted
                )
                request.httpBody = jsonData
            }
        }
        
        request.httpMethod = method.rawValue
        
        if useDefaultHeaders {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        additionalHeaders?.forEach {(request.addValue($0.value, forHTTPHeaderField: $0.key))}
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let result = try self.processResponse(
            responseData: data,
            response: response,
            responseType: responseType
        )
        return result
    }
}

private extension NetworkUtil {
    
    func processResponse<T: Codable, H: Codable>(
        responseData: Data?,
        response: URLResponse?,
        responseType: T.Type,
        headerResponseType: H.Type?,
        isTesting: Bool = false
    ) throws -> Response<T, H> {
        
#if !PRODUCTION
        print("𐫰_______URL RESPONSE_______𐫰")
        print(response?.url as Any)
        print("𐫰_______RESPONSE DATA_______𐫰")
        print(responseData?.prettyPrintedJSONString as Any)
        print("𐫰___________________________𐫰")
#endif
        
        guard let data = responseData else {
            throw NetworkError.noDataReturned
        }
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
            
        }
        
        let statusCode = response.statusCode
        
        do {
            switch statusCode {
            case 200..<300:
                //                setAuthTokens(with: response)
                
                let headerData = try? JSONSerialization.data(withJSONObject: response.allHeaderFields, options: [.prettyPrinted])
                
                let bodyResponse = try decode(
                    data,
                    headerData: headerData ?? Data(),
                    dataResponse: T.self,
                    headerResponse: H.self
                )
                return bodyResponse
            case 300..<400:
                throw NetworkError.redirectError
            case 400..<500:
                //                if statusCode == 401 {
                //                    DispatchQueue.main.async { SessionManager.main.logout() }
                //                }
                let payload = try jsonSerializeOrError(data)
                throw NetworkError.clientError(additionalInfo: payload, headerInfo: response.allHeaderFields)
            case 500...:
                let payload = try jsonSerializeOrError(data)
                throw NetworkError.serverError(additionalInfo: payload)
            default:
                throw NetworkError.unknownError
            }
        } catch let error {
            guard statusCode == 204 else { throw error }
            
            let noContent = try JSONSerialization.data(
                withJSONObject: ["status": 204],
                options: .prettyPrinted
            )
            let res = try decode(
                noContent,
                headerData: noContent,
                dataResponse: responseType,
                headerResponse: headerResponseType
            )
            return res
        }
        
    }
    
    func processResponse<T: Codable>(
        responseData: Data?,
        response: URLResponse?,
        responseType: T.Type,
        isTesting: Bool = false
    ) throws -> T {
        
#if !PRODUCTION
        print("🟡_______URL RESPONSE_______🟡")
        print(response as Any)
        print("🟢_______RESPONSE DATA_______🟢")
        print(responseData?.prettyPrintedJSONString as Any)
        print("🟢___________________________🟢")
#endif
        
        guard let data = responseData else {
            throw NetworkError.noDataReturned
        }
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
            
        }
        
        let statusCode = response.statusCode
        
        do {
            switch statusCode {
            case 200..<300:
                //                setAuthTokens(with: response)
                return try decode(data)
            case 300..<400:
                throw NetworkError.redirectError
            case 400..<500:
                //                if statusCode == 401 {
                //                    DispatchQueue.main.async { SessionManager.main.logout() }
                //                }
                let payload = try jsonSerializeOrError(data)
                throw NetworkError.clientError(additionalInfo: payload, headerInfo: response.allHeaderFields)
            case 500...:
                let payload = try jsonSerializeOrError(data)
                throw NetworkError.serverError(additionalInfo: payload)
            default:
                throw NetworkError.unknownError
            }
        } catch let error {
            guard statusCode == 204 else { throw error }
            
            let noContent = try JSONSerialization.data(
                withJSONObject: ["status": 204],
                options: .prettyPrinted
            )
            
            return try decode(noContent)
        }
        
    }
    
    func decode<T: Codable, H: Codable>(
        _ data: Data,
        headerData: Data,
        dataResponse: T.Type = T.self,
        headerResponse: H.Type? = H.self
    ) throws -> Response<T, H> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        
        let body = try decoder.decode(T.self, from: data.isEmpty ? JSONEncoder().encode(EmptyResponse()) : data)
        
        let header = try decoder.decode(
            H.self,
            from: headerData.isEmpty ? JSONEncoder().encode(EmptyResponse()) : headerData
        )
        
        let response = Response(body: body, header: header)
        return response
    }
    
    func decode<T: Codable> (_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        
        return try decoder.decode(T.self, from: data.isEmpty ? JSONEncoder().encode(EmptyResponse()) : data)
    }
    
    func jsonSerializeOrError(_ data: Data) throws -> [String: Any] {
        guard let json = try JSONSerialization.jsonObject(
            with: data, options: []
        ) as? [String: Any] else { throw NetworkError.unknownError }
        
        return json
    }
}
