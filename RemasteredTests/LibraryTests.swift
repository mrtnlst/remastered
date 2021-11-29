//
//  LibraryTests.swift
//  RemasteredTests
//
//  Created by martin on 14.11.21.
//

import XCTest
import ComposableArchitecture
@testable import Remastered

class LibraryTests: XCTestCase {
    let scheduler = DispatchQueue.test
    
    enum Constants {
        static let artist = "Artist"
        static let title = "Title"
        static let id = "40fff5a3-26d7"
        static let dateAdded = Date()
        static let lastPlayed = Date()
        static let isFavorite = true
        static let artwork = UIImage()
        static let uuid = UUID(uuidString: "40fff5a3-26d7-446f-9bbb-498babaaaa91")!
    }
    
    let libraryCollection: LibraryCollection = .init(
        title: Constants.title,
        artist: Constants.artist,
        id: Constants.id,
        dateAdded: Constants.dateAdded,
        lastPlayed: Constants.lastPlayed,
        isFavorite: Constants.isFavorite,
        artwork: Constants.artwork,
        items: []
    )
    
    let categoryModels: [LibraryCategoryModel] = [
        LibraryCategoryModel(
            type: .albums,
            items: [
                LibraryCollection(
                    title: Constants.title,
                    artist: Constants.artist,
                    id: Constants.id,
                    dateAdded: Constants.dateAdded,
                    lastPlayed: Constants.lastPlayed,
                    isFavorite: Constants.isFavorite,
                    artwork: Constants.artwork,
                    items: []
                )
            ]
        )
    ]
    
    let categories: [LibraryCategoryState] = [
        LibraryCategoryState(
            items: [
                LibraryItemState(
                    item: LibraryCollection(
                        title: Constants.title,
                        artist: Constants.artist,
                        id: Constants.id,
                        dateAdded: Constants.dateAdded,
                        lastPlayed: Constants.lastPlayed,
                        isFavorite: Constants.isFavorite,
                        artwork: Constants.artwork,
                        items: []
                    ),
                    id: Constants.uuid
                )
            ],
            type: .albums,
            id: Constants.uuid
        )
    ]
    
    func testFetchSuccess() {
        let store = TestStore(
            initialState: LibraryState(),
            reducer: libraryReducer,
            environment: LibraryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: self.categoryModels) },
                uuid: { Constants.uuid }
            )
        )
        store.send(.fetch)
        scheduler.advance()
        store.receive(.receiveCategoryModels(result: .success(categoryModels))) {
            $0.categories =  .init(uniqueElements: self.categories)
        }
    }
    
    func testFetchFailure() {
        let store = TestStore(
            initialState: LibraryState(),
            reducer: libraryReducer,
            environment: LibraryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: []) },
                uuid: { Constants.uuid }
            )
        )
        
        let expectedCategories: [LibraryCategoryModel] = []
  
        store.send(.fetch)
        scheduler.advance()
        store.receive(.receiveCategoryModels(result: .success(expectedCategories))) {
            $0.categories = []
        }
    }
}
