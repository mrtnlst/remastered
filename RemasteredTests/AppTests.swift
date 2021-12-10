//
//  AppTests.swift
//  RemasteredTests
//
//  Created by martin on 14.11.21.
//

import XCTest
import ComposableArchitecture
@testable import Remastered

class AppTests: XCTestCase {
    let scheduler = DispatchQueue.test
    
    func testAuthorizationSuccess() {
        let store = TestStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                libraryService: MockLibraryService(
                    mockFetch: { .none }
                ),
                authorizationService: MockAuthorizationService(mockAuthorize: { Effect(value: true) }),
                playbackService: DefaultPlaybackService()
            )
        )
                
        store.send(.onAppear)
        scheduler.advance()
        store.receive(.authorizationResponse(.success(true))) {
            $0.library = LibraryState()
            $0.gallery = GalleryState()
            $0.isAuthorized = true
        }
        store.receive(.fetch)
    }
    
    func testAuthorizationFailure() {
        let store = TestStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                libraryService: MockLibraryService(
                    mockFetch: { return .none }
                ),
                authorizationService: MockAuthorizationService(mockAuthorize: { Effect(error: .authorizationFailed) }),
                playbackService: DefaultPlaybackService()
            )
        )
        
        store.send(.onAppear)
        scheduler.advance()
        store.receive(.authorizationResponse(.failure(.authorizationFailed))) {
            $0.library = nil
            $0.gallery = nil
            $0.isAuthorized = false
        }
    }
}
