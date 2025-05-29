//
//  MockCharacterRepository.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/29/25.
//

import Foundation

class MockCharacterRepository: CharacterRepositoryProtocol {
    var _characters: [Character] = [
        .init(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            episode: [""],
            gender: "Male",
            origin: nil,
            location: nil,
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            created: "2017-11-04T18:48:46.250Z"
        ),
        .init(
            id: 2,
            name: "Tim Cook",
            status: "Alive",
            species: "Alien",
            episode: [""],
            gender: "Male",
            origin: nil,
            location: nil,
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            created: "2017-11-04T18:48:46.250Z"
        )
    ]
    
    func getCharacters(cached: Bool) async throws -> [Character] {
        return _characters
    }
}
