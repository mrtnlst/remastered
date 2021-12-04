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
                    fetch: $0.libraryService.fetch,
                    uuid: { UUID.init() }
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
                    fetch: $0.libraryService.fetch,
                    uuid: { UUID.init() }
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
            return Effect(value: .fetch)

        case .authorizationResponse(.success(false)),
                .authorizationResponse(.failure(_)):
            state.library = nil
            state.gallery = nil
            return .none
            
        case let .library(.libraryCategory(id: _, action: .libraryItem(id: _, action: .didSelectItem(id: id, type: type)))):
            return environment
                .playbackService
                .play(id: id, of: type)
                .subscribe(on: environment.mainQueue)
                .fireAndForget()
            
        case .library(_):
            return .none
            
        case .fetch:
            return environment
                .libraryService
                .fetch()
                .receive(on: environment.mainQueue)
                .catchToEffect(AppAction.fetchResponse)
    
        case let .fetchResponse(.success(collections)):
            return .merge(
                Effect(value: .library(.receiveCollections(result: .success(collections)))),
                Effect(value: .gallery(.receiveCollections(result: .success(collections))))
            )
            
        case let .gallery(.didSelectItem(id)):
            return environment
                .playbackService
                .play(id: id, of: .albums)
                .subscribe(on: environment.mainQueue)
                .fireAndForget()
            
        case .gallery(_):
            return .none
    
        }
    }
)
