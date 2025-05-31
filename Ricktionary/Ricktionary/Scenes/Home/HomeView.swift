//
//  HomeView.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/27/25.
//

import SwiftUI

struct HomeView: View {
    private let keychainService = KeychainService()
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.characterList, id: \.id) { character in
                NavigationLink(destination: DetailView(character: character)) {
                    VStack(alignment: .leading) {
                        Text(character.name ?? "")
                            .font(.headline)
                        Text(character.status ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Ricktionary")

            .onAppear {
                viewModel.getAllCharacters()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let client = MockCharacterClient()
        let repo = MockCharacterRepository()
        HomeView(viewModel: HomeViewModel(client: client, repository: repo))
    }
}

