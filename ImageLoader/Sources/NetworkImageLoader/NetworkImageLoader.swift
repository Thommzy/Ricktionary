//
//  NetworkImage.swift
//  ImageLoader
//
//  Created by Timothy Obeisun on 5/29/25.
//

import Foundation
import SwiftUI
import Combine

/// An observable object responsible for asynchronously loading an image from a URL
/// and publishing it for SwiftUI views to consume.
///
/// This loader fetches image data on a background thread and updates the published
/// `image` property on the main thread to ensure UI consistency.
///
@MainActor
public class NetworkImageLoader: ObservableObject {
    
    /// The loaded image published to any SwiftUI views observing this loader.
    @Published public var image: UIImage?
    
    /// The URL from which the image will be fetched.
    private var url: URL?
    
    /// Initializes the image loader with a given URL and starts loading immediately.
    ///
    /// - Parameter url: An optional URL to fetch the image from.
    public init(url: URL?) {
        self.url = url
        loadImage()
    }
    
    /// Loads the image asynchronously from the stored URL.
    /// If the URL is nil or loading fails, the `image` remains nil.
    ///
    /// The network call is performed on a background thread, and the image
    /// assignment happens on the main actor to keep UI updates thread-safe.
    public func loadImage() {
        guard let url else { return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                Task { @MainActor in
                    self.image = image
                }
            }
        }
    }
}
