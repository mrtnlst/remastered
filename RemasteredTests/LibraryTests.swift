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
        type: .albums,
        title: Constants.title,
        artist: Constants.artist,
        id: Constants.id,
        dateAdded: Constants.dateAdded,
        lastPlayed: Constants.lastPlayed,
        isFavorite: Constants.isFavorite,
        artwork: Constants.artwork,
        items: []
    )
    
    let categories: [LibraryCategoryState] = [
        LibraryCategoryState(
            id: Constants.uuid,
            items: [
                LibraryItemState(
                    item: LibraryCollection(
                        type: .albums,
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
            name: LibraryCategoryType.albums.rawValue,
            icon: LibraryCategoryType.albums.icon
        )
    ]
    
    func testFetchSuccess() {
        let store = TestStore(
            initialState: LibraryState(),
            reducer: libraryReducer,
            environment: LibraryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: [self.libraryCollection]) },
                uuid: { Constants.uuid }
            )
        )
        store.send(.fetch)
        scheduler.advance()
        store.receive(.receiveCollections(result: .success([self.libraryCollection]))) {
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
        
        let expectedCollections: [LibraryCollection] = []
  
        store.send(.fetch)
        scheduler.advance()
        store.receive(.receiveCollections(result: .success(expectedCollections))) {
            $0.categories = []
        }
    }
}
