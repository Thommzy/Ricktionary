//
//  PaginatedDefaultResponse.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/28/25.
//

import Foundation

struct PaginatedDefaultResponse<T: Codable>: Codable {
    var results: [T]?

    enum CodingKeys: String, CodingKey {
        case results
    }
}

