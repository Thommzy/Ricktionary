//
//  NetworkImage.swift
//  ImageLoader
//
//  Created by Timothy Obeisun on 5/29/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
public class NetworkImageLoader: ObservableObject {
    @Published public var image: UIImage?
    private var url: URL?
    
    public init(url: URL?) {
        self.url = url
        loadImage()
    }
    
    public func loadImage() {
        guard let url else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                Task { @MainActor in
                    self.image = image
                }
            }
        }
    }
}
