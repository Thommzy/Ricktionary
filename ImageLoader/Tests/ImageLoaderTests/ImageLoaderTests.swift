@testable import ImageLoader
import XCTest


final class NetworkImageLoaderTests: XCTestCase {
    
    @MainActor func testImageLoadsSuccessfullyFromValidURL() {
        // Arrange
        let expectation = XCTestExpectation(description: "Image loads successfully")
        let imageURLString = "https://rickandmortyapi.com/api/character/avatar/20.jpeg"
        guard let url = URL(string: imageURLString) else {
            XCTFail("Invalid URL")
            return
        }
        
        let loader = NetworkImageLoader(url: url)
        
        // Act
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if loader.image != nil {
                expectation.fulfill()
            } else {
                XCTFail("Image failed to load")
            }
        }
        
        // Assert
        wait(for: [expectation], timeout: 10.0)
    }
    
    @MainActor func testImageLoaderWithNilURLDoesNotLoadImage() {
        // Arrange
        let loader = NetworkImageLoader(url: nil)
        
        // Act & Assert
        XCTAssertNil(loader.image, "Image should be nil when initialized with nil URL")
    }
}
