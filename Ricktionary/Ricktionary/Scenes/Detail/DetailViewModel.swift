//
//  DetailViewModel.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/29/25.
//

import Combine
import UIKit

final class DetailViewModel: ObservableObject {
    @Published var character: Character
    private var cancellable: AnyCancellable?
    
    init(character: Character) {
        self.character = character
    }
}
