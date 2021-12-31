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
        static let uuid = UUID.customUUID(from: Constants.id)
    }
    
    var libraryCollection: LibraryCollection {
        .init(
            type: .album,
            title: Constants.title,
            subtitle: Constants.artist,
            id: Constants.id,
            dateAdded: Constants.dateAdded,
            lastPlayed: Constants.lastPlayed,
            isFavorite: Constants.isFavorite,
            artwork: Constants.artwork,
            items: []
        )
    }
    
    var categories: [LibraryCategoryState] {
        [
            LibraryCategoryState(
                id: LibraryCategoryType.playlist.uuid,
                items: [],
                name: LibraryCategoryType.playlist.text,
                icon: LibraryCategoryType.playlist.icon
            ),
            LibraryCategoryState(
                id: LibraryCategoryType.artist.uuid,
                items: [],
                name: LibraryCategoryType.artist.text,
                icon: LibraryCategoryType.artist.icon
            ),
            LibraryCategoryState(
                id: LibraryCategoryType.album.uuid,
                items: [LibraryItemState(collection: libraryCollection, id: Constants.uuid)],
                name: LibraryCategoryType.album.text,
                icon: LibraryCategoryType.album.icon
            ),
            LibraryCategoryState(
                id: LibraryCategoryType.song.uuid,
                items: [],
                name: LibraryCategoryType.song.text,
                icon: LibraryCategoryType.song.icon
            ),
            LibraryCategoryState(
                id: LibraryCategoryType.genre.uuid,
                items: [],
                name: LibraryCategoryType.genre.text,
                icon: LibraryCategoryType.genre.icon
            )
        ]
    }
    
    func testFetchSuccess() {
        let store = TestStore(
            initialState: LibraryState(categories: LibraryState.initialCategories),
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
