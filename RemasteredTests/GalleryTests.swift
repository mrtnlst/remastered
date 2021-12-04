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
    
    let galleryModels: [GalleryRowModel] = [
        GalleryRowModel(
            id: Constants.uuid,
            items: [
                LibraryCollection(
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
            ],
            type: .recentlyAdded
        )
    ]
    
    func testFetchSuccess() {
        let store = TestStore(
            initialState: GalleryState(),
            reducer: galleryReducer,
            environment: GalleryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: [self.libraryCollection]) },
                uuid: { Constants.uuid }
            )
        )

        var expectedModels: [GalleryRowModel] = []
        GalleryRowModel.RowType.allCases.forEach { type in
            let model = GalleryRowModel(
                id: Constants.uuid,
                items: [
                    LibraryCollection(
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
                ],
                type: type
            )
            expectedModels.append(model)
        }
        
        store.send(.fetch)
        scheduler.advance()
        store.receive(.receiveCollections(result: .success([self.libraryCollection]))) {
            $0.galleryRowModels = expectedModels
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
            $0.galleryRowModels = []
        }
    }
}
