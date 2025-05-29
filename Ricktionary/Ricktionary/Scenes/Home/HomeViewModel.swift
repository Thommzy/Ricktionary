//
//  HomeViewModel.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/28/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    let client: CharacterClientProtocol
    let repository: CharacterRepositoryProtocol
    
    // Use @Published so SwiftUI updates when this changes
    @Published var characterList: [Character] = []
    
    private var cancellables = Set<AnyCancellable>()
    var shopcreated = PassthroughSubject<Void, Never>()
    var shopError = PassthroughSubject<Void, Never>()
    var noInternetError = PassthroughSubject<Void, Never>()
    var serverError = PassthroughSubject<String, Never>()
    var characters = CurrentValueSubject<[Character]?, Never>(nil)
    var isProductTab: CurrentValueSubject<Bool?, Never> = .init(nil)
    var isShopNew: CurrentValueSubject<Bool?, Never> = .init(false)
    
    init(client: CharacterClientProtocol,
         repository: CharacterRepositoryProtocol) {
        self.client = client
        self.repository = repository
        
        // Sync Combine stream to @Published variable
        characters
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.characterList = $0
            }
            .store(in: &cancellables)
    }
    
    func getAllCharacters(cached: Bool = true) {
        Task {
            do {
                let req = try await repository.getCharacters(cached: cached)
                characters.send(req)
            } catch {
                characters.send(characters.value ?? [])
            }
        }
    }
}
