//
//  MockClient.swift
//  RicktionaryTests
//
//  Created by Timothy Obeisun on 5/31/25.
//

@testable import Ricktionary

class MockClient: CharacterClientProtocol {
    var response: PaginatedDefaultResponse<Character>

    init(response: PaginatedDefaultResponse<Character>) {
        self.response = response
    }

    func getCharacters() async throws -> PaginatedDefaultResponse<Character> {
        return response
    }
}
