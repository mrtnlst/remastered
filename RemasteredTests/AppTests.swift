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
                    mockFetch: { .none },
                    mockFetchCollection: { _, _ in return .none }
                ),
                authorizationService: MockAuthorizationService(mockAuthorize: { Effect(value: true) }),
                playbackService: DefaultPlaybackService()
            )
        )
                
        store.send(.onAppear)
        store.receive(.didBecomeActive)
        scheduler.advance()
        store.receive(.authorizationResponse(.success(true))) {
            $0.library = LibraryState()
            $0.gallery = GalleryState(rows: GalleryState.initialRows)
            $0.search = SearchState()
            $0.playback = PlaybackState()
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
                    mockFetch: { return .none },
                    mockFetchCollection: { _, _ in return .none }
                ),
                authorizationService: MockAuthorizationService(mockAuthorize: { Effect(error: .authorizationFailed) }),
                playbackService: DefaultPlaybackService()
            )
        )
        
        store.send(.onAppear)
        store.receive(.didBecomeActive)
        scheduler.advance()
        store.receive(.authorizationResponse(.failure(.authorizationFailed))) {
            $0.library = nil
            $0.gallery = nil
            $0.playback = nil
            $0.search = nil
            $0.isAuthorized = false
        }
    }
}
