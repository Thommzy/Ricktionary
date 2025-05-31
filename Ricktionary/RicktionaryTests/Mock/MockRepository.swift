//
//  MockRepository.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/31/25.
//

@testable import Ricktionary

class MockRepository: CharacterRepositoryProtocol {
    var _characters: [Character]

    let client: CharacterClientProtocol

    init(client: CharacterClientProtocol, characters: [Character] = []) {
        self.client = client
        self._characters = characters
    }

    func getCharacters(cached: Bool) async throws -> [Character] {
        let response = try await client.getCharacters()
        return response.results ?? []
    }
}
