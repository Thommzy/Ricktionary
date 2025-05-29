//
//  CharacterClient.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/28/25.
//

import Foundation

protocol CharacterClientProtocol {
    func getCharacters() async throws -> PaginatedDefaultResponse<Character>
}

class CharacterClient: CharacterClientProtocol, NetworkUtil {
    func getCharacters() async throws -> PaginatedDefaultResponse<Character> {
        let url = baseUrl.appendingPathComponent("character", isDirectory: false)
        
        return try await self.request(
            url: url,
            method: .get,
            bodyParam: nil,
            queryParam: nil,
            expecting: PaginatedDefaultResponse<Character>.self,
            authenticate: false,
            useBasicAuth: false
        )
    }
}
