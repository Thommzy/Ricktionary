//
//  Characters.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/28/25.
//

import Foundation

struct Characters: Codable {
    let results: [Character]?
}

struct Character: Codable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let episode: [String]?
    let gender: String?
    let origin: Location?
    let location: Location?
    let image: String?
    let created: String?
}

struct Location: Codable {
    let name: String
}

struct PaginationInfo {
    var count = 0
    var pages = 42
    var next: String? = ""
    var prev: String? = ""
    var page = 0

    mutating func reset() {
        prev = nil
        page = 0
    }
}
