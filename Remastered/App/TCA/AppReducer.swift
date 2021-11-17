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
            environment: { environment in
                FavoritesEnvironment(
                    mainQueue: environment.mainQueue,
                    fetch: environment.favoritesRepository.fetch,
                    delete: { id in environment.favoritesRepository.delete(id: id) },
                    save: { id, position in environment.favoritesRepository.save(id: id, position: position) }
                )
            }
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
            return Effect(value: .favorites(.fetchFavorites))

        case .authorizationResponse(.success(false)),
                .authorizationResponse(.failure(_)):
            state.library = nil
            
        case let .library(.libraryAlbumSelected(id)):
            return Effect(value: .favorites(.saveFavorite(id: id)))
            
        case .library(_):
            return .none
        
        case let .setLibrary(isPresenting):
            state.isLibraryPresenting = isPresenting
            
        case let .favorites(.receiveFavorites(.success(favorites))):
            return Effect(value: .library(.receiveFavoriteAlbums(favorites)))
            
        case .favorites(_):
            return .none
        }
        return .none
    }
)
