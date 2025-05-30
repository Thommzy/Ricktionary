//
//  NetworkError.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/28/25.
//

import Foundation

enum NetworkError: Error {
    case missingAccessToken
    case missingParam
    case missingStatusCode
    case noDataReturned
    case redirectError
    case clientError(additionalInfo: [String: Any]?, headerInfo: [AnyHashable: Any]?)
    case serverError(additionalInfo: [String: Any]?)
    case methodNotSupported
    case noResponse
    case missingUrl
    case unknownError

    var reason: String {
        switch self {
        case .missingAccessToken:
            return "An error occurred while accessing stored access token"
        case .missingParam:
            return "An error occurred while accessing parameters"
        case .missingUrl:
            return "An error occurred while unwrapping URL"
        case .missingStatusCode:
            return "An error occurred while accessing status code"
        case .noResponse:
            return "No response returned from server"
        case .noDataReturned:
            return "An error occurred while fetching data"
        case .unknownError:
            return "An unknown error occurred while fetching data"
        case .redirectError:
            return "Redirect errors occurred while processing request"
        case .clientError:
            return "A client error occurred while processing request"
        case .serverError:
            return "Server errors occurred while processing request"
        case .methodNotSupported:
            return "Request Method not supported"
        }
    }
}
