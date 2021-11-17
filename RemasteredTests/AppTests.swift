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
            initialState: AppState(favorites: FavoritesState()),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                libraryService: MockLibraryService(mockFetch: { return .none }),
                authorizationService: MockAuthorizationService(mockAuthorize: { Effect(value: true) }),
                favoritesRepository: MockFavoritesRepository(
                    mockFetch: { Effect(value: MockFavoritesRepository.mockFavorites) },
                    mockDelete: { _ in return .none },
                    mockSave: { _, _ in return .none }
                )
            )
        )
        
        let expectedFavorites = MockFavoritesRepository.mockFavorites
        
        store.send(.onAppear)
        scheduler.advance()
        store.receive(.authorizationResponse(.success(true))) {
            $0.library = LibraryState()
        }
        store.receive(.favorites(.fetchFavorites))
        store.receive(.favorites(.receiveFavorites(.success(expectedFavorites)))) {
            $0.favorites.favorites = expectedFavorites
        }
        store.receive(.library(.receiveFavoriteAlbums(expectedFavorites))) {
            $0.library?.favorites = expectedFavorites
        }
    }
    
    func testAuthorizationFailure() {
        let store = TestStore(
            initialState: AppState(favorites: FavoritesState()),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                libraryService: MockLibraryService(mockFetch: { return .none }),
                authorizationService: MockAuthorizationService(mockAuthorize: { Effect(error: .authorizationFailed) }),
                favoritesRepository: DefaultFavoritesRepository()
            )
        )
        
        store.send(.onAppear)
        scheduler.advance()
        store.receive(.authorizationResponse(.failure(.authorizationFailed))) {
            $0.library = nil
        }
    }
    
    func testSetLibraryPresenting() {
        let store = TestStore(
            initialState: AppState(favorites: FavoritesState()),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                libraryService: MockLibraryService(mockFetch: { return .none }),
                authorizationService: MockAuthorizationService(mockAuthorize: { return .none }),
                favoritesRepository: DefaultFavoritesRepository()
            )
        )
        
        store.send(.setLibrary(isPresenting: true)) {
            $0.isLibraryPresenting = true
        }
        store.send(.setLibrary(isPresenting: false)) {
            $0.isLibraryPresenting = false
        }
    }
}
