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
    
    func testFetchSuccess() {
        let store = TestStore(
            initialState: LibraryState(),
            reducer: libraryReducer,
            environment: LibraryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: LibraryRowModel.exampleRowModels) }
            )
        )

        let expectedRows = LibraryRowModel.exampleRowModels

        store.send(.fetch)
        scheduler.advance()
        store.receive(.receiveLibraryItems(result: .success(expectedRows))) {
            $0.libraryRowModels = LibraryRowModel.exampleRowModels
        }
    }
    
    func testFetchFailure() {
        let store = TestStore(
            initialState: LibraryState(),
            reducer: libraryReducer,
            environment: LibraryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetch: { Effect(value: []) }
            )
        )
        
        let expectedRows: [LibraryRowModel] = []
  
        store.send(.fetch)
        scheduler.advance()
        store.receive(.receiveLibraryItems(result: .success(expectedRows))) {
            $0.libraryRowModels = []
        }
    }
}
