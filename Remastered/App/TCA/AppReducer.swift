//
//  AppReducer.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    favoritesReducer
        .pullback(
            state: \.favorites,
            action: /AppAction.favorites,
            environment: { FavoritesEnvironment(favoritesService: $0.favoritesService) }
    ),
    libraryReducer
        .optional()
        .pullback(
            state: \.library,
            action: /AppAction.library,
            environment: {
                LibraryEnvironment(
                    mainQueue: $0.mainQueue,
                    fetch: $0.libraryService.fetch
                )
            }
    ),
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            return environment
                .authorizationService
                .authorize()
                .receive(on: environment.mainQueue)
                .catchToEffect(AppAction.authorizationResponse)

        case .authorizationResponse(.success(true)):
            state.library = LibraryState()
            
        case .authorizationResponse(.success(false)),
                .authorizationResponse(.failure(_)):
            state.library = nil
            
        case .library(_):
            return .none
        
        case let .setLibrary(isPresenting):
            state.isLibraryPresenting = isPresenting
            
        case .favorites(_):
            return .none
        }
        return .none
    }
)
