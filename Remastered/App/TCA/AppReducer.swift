//
//  AppReducer.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    libraryReducer
        .optional()
        .pullback(
            state: \.library,
            action: /AppAction.library,
            environment: {
                LibraryEnvironment(
                    mainQueue: $0.mainQueue,
                    fetch: $0.libraryService.fetchLibraryItems
                )
            }
    ),
    galleryReducer
        .optional()
        .pullback(
            state: \.gallery,
            action: /AppAction.gallery,
            environment: {
                GalleryEnvironment(
                    mainQueue: $0.mainQueue,
                    fetch: $0.libraryService.fetchGalleryItems
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
            state.gallery = GalleryState()
            return .merge(
                Effect(value: .gallery(.fetch)),
                Effect(value: .library(.fetch))
            )

        case .authorizationResponse(.success(false)),
                .authorizationResponse(.failure(_)):
            state.library = nil
            state.gallery = nil
            return .none
            
        case let .library(.didSelectItem(id)):
            return environment
                .playbackService
                .play(for: id)
                .subscribe(on: environment.mainQueue)
                .fireAndForget()
            
        case .library(_):
            return .none
    
        case let .gallery(.didSelectItem(id)):
            return environment
                .playbackService
                .play(for: id)
                .subscribe(on: environment.mainQueue)
                .fireAndForget()
            
        case .gallery(_):
            return .none
    
        }
    }
)
