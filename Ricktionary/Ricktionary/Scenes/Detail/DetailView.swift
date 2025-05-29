//
//  DetailView.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/29/25.
//
import SwiftUI

struct DetailView: UIViewControllerRepresentable {
    let character: Character
    
    func makeUIViewController(context: Context) -> DetailViewController {
        let viewModel = DetailViewModel(character: character)
        return DetailViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {}
}
