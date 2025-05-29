//
//  DetailViewModel.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/29/25.
//

import ImageLoader
import Combine
import UIKit

final class DetailViewModel: ObservableObject {
    @Published var character: Character
    private var cancellable: AnyCancellable?
    
    init(character: Character) {
        self.character = character
    }
    
    @MainActor func fetchCharacterImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let loader = NetworkImageLoader(url: url)
        cancellable = loader.$image
            .sink(receiveValue: { image in
                completion(image)
            })
    }
}
