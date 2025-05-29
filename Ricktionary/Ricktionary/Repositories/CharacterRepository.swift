//
//  CharacterRepository.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/28/25.
//

import Foundation

protocol CharacterRepositoryProtocol {
    var _characters: [Character] {get}
    func getCharacters(cached: Bool) async throws -> [Character]
}

final class CharacterRepository: CharacterRepositoryProtocol {
    let client: CharacterClient
    
    var _characters: [Character] {
        characters
    }
    
    init(client: CharacterClient) {
        self.client = client
    }
    
    private var characters: [Character] = []
    private var productItemsPaginationData = PaginationInfo()
    
    func getCharacters(cached: Bool) async throws -> [Character] {
        if !cached {
            cached ? () : productItemsPaginationData.reset()
            characters = []
        }
        
        if productItemsPaginationData.next != nil {
            let req = try await client.getCharacters()
            let updatedData = characters + (req.results ?? [])
            let sortedData = updatedData.sorted { $0.name?.lowercased() ?? "" < $1.name?.lowercased() ?? "" }
            characters = sortedData
            productItemsPaginationData.page += 1
            return characters
        } else {
            return characters
        }
    }
}
