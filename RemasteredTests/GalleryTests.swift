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
    
    func testFetchSuccess() {
        let store = TestStore(
            initialState: GalleryState(),
            reducer: galleryReducer,
            environment: GalleryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: GalleryRowModel.exampleRowModels) }
            )
        )

        let expectedRows = GalleryRowModel.exampleRowModels

        store.send(.fetch)
        scheduler.advance()
        store.receive(.receiveGalleryItems(result: .success(expectedRows))) {
            $0.galleryRowModels = GalleryRowModel.exampleRowModels
        }
    }
    
    func testFetchFailure() {
        let store = TestStore(
            initialState: GalleryState(),
            reducer: galleryReducer,
            environment: GalleryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: []) }
            )
        )
        
        let expectedRows: [GalleryRowModel] = []
  
        store.send(.fetch)
        scheduler.advance()
        store.receive(.receiveGalleryItems(result: .success(expectedRows))) {
            $0.galleryRowModels = []
        }
    }
}
