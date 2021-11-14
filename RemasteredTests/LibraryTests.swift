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
    
    func testFetchAlbumsSuccess() {
        let store = TestStore(
            initialState: LibraryState(),
            reducer: libraryReducer,
            environment: LibraryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: LibraryAlbum.exampleAlbums) }
            )
        )
        
        let expectedAlbums = LibraryAlbum.exampleAlbums
  
        store.send(.fetchAlbums)
        scheduler.advance()
        store.receive(.receiveAlbums(result: .success(expectedAlbums))) {
            $0.albums = expectedAlbums
        }
    }
    
    func testFetchAlbumsFailure() {
        let store = TestStore(
            initialState: LibraryState(),
            reducer: libraryReducer,
            environment: LibraryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: []) }
            )
        )
        
        let expectedAlbums: [LibraryAlbum] = []
  
        store.send(.fetchAlbums)
        scheduler.advance()
        store.receive(.receiveAlbums(result: .success(expectedAlbums))) {
            $0.albums = expectedAlbums
        }
    }
}
