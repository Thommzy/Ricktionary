//
//  Environment.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/28/25.
//

import Foundation

public enum Environment {
    static let baseUrl: URL = {
        guard let url = URL(string: "https://rickandmortyapi.com/api/") else {
            fatalError("SERVER_BASE_URL is invalid")
        }
        return url
    }()
}
