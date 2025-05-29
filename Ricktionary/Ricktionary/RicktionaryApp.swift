//
//  RicktionaryApp.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/27/25.
//

import SwiftUI

@main
struct RicktionaryApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: createViewModel())
        }
    }

    func createViewModel() -> HomeViewModel {
        let client = CharacterClient()
        let repository = CharacterRepository(client: client)
        return HomeViewModel(client: client, repository: repository)
    }
}
