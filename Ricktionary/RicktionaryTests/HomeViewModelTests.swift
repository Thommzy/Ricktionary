//
//  HomeViewModelTests.swift
//  RicktionaryTests
//
//  Created by Timothy Obeisun on 5/30/25.
//

import XCTest
import Combine
@testable import Ricktionary

final class HomeViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []

    // MARK: - Test

    func testGetAllCharacters_ShouldPopulateCharacterList() async {
        // Arrange
        let dummyCharacter = Character(
            id: 0,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            episode: [],
            gender: "Male",
            origin: nil,
            location: nil,
            image: "",
            created: ""
        )
        let response = PaginatedDefaultResponse<Character>(
            results: [dummyCharacter]
        )

        let mockClient = MockClient(response: response)
        let mockRepository = MockRepository(client: mockClient)
        let viewModel = HomeViewModel(client: mockClient, repository: mockRepository)

        let expectation = XCTestExpectation(description: "characterList should update")

        viewModel.$characterList
            .dropFirst()
            .sink { characters in
                XCTAssertEqual(characters.count, 1)
                XCTAssertEqual(characters.first?.name, "Rick Sanchez")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Act
        viewModel.getAllCharacters()

        // Assert
        await fulfillment(of: [expectation], timeout: 2.0)
    }
}
