//
//  GalleryTests.swift
//  RemasteredTests
//
//  Created by martin on 28.11.21.
//

import XCTest
import ComposableArchitecture
@testable import Remastered

class GalleryTests: XCTestCase {
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
        LibraryCollection(
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
    
    var libraryItemState: LibraryItemState {
        LibraryItemState(
            collection: libraryCollection,
            id: Constants.uuid
        )
    }
    var discoverCategory: LibraryCategoryState {
        LibraryCategoryState(
            id: GalleryCategoryType.discover.uuid,
            items: [libraryItemState],
            name: GalleryCategoryType.discover.rawValue
        )
    }
    var favoritesCategory: LibraryCategoryState {
        LibraryCategoryState(
            id: GalleryCategoryType.favorites.uuid,
            items: [libraryItemState],
            name: GalleryCategoryType.favorites.rawValue
        )
    }
    var addedCategory: LibraryCategoryState {
        LibraryCategoryState(
            id: GalleryCategoryType.recentlyAdded.uuid,
            items: [libraryItemState],
            name: GalleryCategoryType.recentlyAdded.rawValue
        )
    }
    var playedCategory: LibraryCategoryState {
        LibraryCategoryState(
            id: GalleryCategoryType.recentlyPlayed.uuid,
            items: [libraryItemState],
            name: GalleryCategoryType.recentlyPlayed.rawValue
        )
    }
    
    func testFetchSuccess() {
        let store = TestStore(
            initialState: GalleryState(rows: GalleryState.initialRows),
            reducer: galleryReducer,
            environment: GalleryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: [self.libraryCollection]) },
                uuid: { Constants.uuid }
            )
        )
        
        store.send(.fetch)
        scheduler.advance()
        store.receive(.receiveCollections(result: .success([self.libraryCollection])))
        store.receive(
            .galleryRowAction(
                id: GalleryCategoryType.discover.uuid,
                action: .receiveCategory(self.discoverCategory)
            )
        ) {
            
            $0.rows[id: GalleryCategoryType.discover.uuid]?.category = self.discoverCategory
        }
        store.receive(
            .galleryRowAction(
                id: GalleryCategoryType.favorites.uuid,
                action: .receiveCategory(self.favoritesCategory)
            )
        ) {
            $0.rows[id: GalleryCategoryType.favorites.uuid]?.category = self.favoritesCategory
        }
        store.receive(
            .galleryRowAction(
                id: GalleryCategoryType.recentlyAdded.uuid,
                action: .receiveCategory(self.addedCategory)
            )
        ) {
            $0.rows[id: GalleryCategoryType.recentlyAdded.uuid]?.category = self.addedCategory
        }
        store.receive(
            .galleryRowAction(
                id: GalleryCategoryType.recentlyPlayed.uuid,
                action: .receiveCategory(self.playedCategory)
            )
        ) {
            $0.rows[id: GalleryCategoryType.recentlyPlayed.uuid]?.category = self.playedCategory
        }
    }
    
    func testFetchFailure() {
        let store = TestStore(
            initialState: GalleryState(),
            reducer: galleryReducer,
            environment: GalleryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: []) },
                uuid: { Constants.uuid }
            )
        )
        
        let expectedCollections: [LibraryCollection] = []
        
        store.send(.fetch)
        scheduler.advance()
        store.receive(.receiveCollections(result: .success(expectedCollections))) {
            $0.rows = []
        }
    }
}
