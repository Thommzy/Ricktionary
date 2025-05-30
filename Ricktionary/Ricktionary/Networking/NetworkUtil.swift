//
//  NetworkUtil.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/28/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkUtil {
    var baseUrl: URL { get }
    var headers: [String: String] { get }
}

struct Response<T: Codable, H: Codable>: Codable {
    var body: T
    var header: H
}

extension NetworkUtil {
    var baseUrl: URL {
        return Environment.baseUrl
    }

    var headers: [String: String] {
        [
            "Accept": "*/*",
            "Content-Type": "application/json"
        ]
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
        var requestURL = url

        if let queryParam = queryParam {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryParam.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            requestURL = components?.url ?? url
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue

        if let bodyParam = bodyParam {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParam)
        }

        if useDefaultHeaders {
            headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        }

        additionalHeaders?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

        let (data, response) = try await URLSession.shared.data(for: request)
        return try processResponse(data: data, response: response, responseType: responseType)
    }

    private func processResponse<T: Codable>(
        data: Data?,
        response: URLResponse?,
        responseType: T.Type
    ) throws -> T {
        guard let data = data else { throw NetworkError.noDataReturned }
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.noResponse }

        switch httpResponse.statusCode {
        case 200..<300:
            return try decode(data: data, as: T.self)
        case 204:
            let noContent = try JSONSerialization.data(withJSONObject: ["status": 204])
            return try decode(data: noContent, as: T.self)
        case 400..<500:
            let payload = try parseJSON(data)
            throw NetworkError.clientError(additionalInfo: payload, headerInfo: httpResponse.allHeaderFields)
        case 500...:
            let payload = try parseJSON(data)
            throw NetworkError.serverError(additionalInfo: payload)
        default:
            throw NetworkError.unknownError
        }
    }

    private func decode<T: Codable>(data: Data, as type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return try decoder.decode(T.self, from: data)
    }

    private func parseJSON(_ data: Data) throws -> [String: Any] {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NetworkError.unknownError
        }
        return json
    }
}
