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
            state.isAuthorized = true
            return Effect(value: .fetch)

        case .authorizationResponse(.success(false)),
                .authorizationResponse(.failure(_)):
            state.library = nil
            state.gallery = nil
            state.isAuthorized = false
            return .none
            
        case let .library(.libraryCategory(action: .libraryItem(id: _, action: .didSelectItem(id, type, position)))),
            let .gallery(.libraryCategory(action: .libraryItem(id: _, action: .didSelectItem(id, type, position)))),
            let .library(.libraryItem(action: .didSelectItem(id, type, position))),
            let .gallery(.libraryItem(action: .didSelectItem(id, type, position))):
            return environment
                .playbackService
                .play(id: id, of: type, from: position)
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
            
        case let .didSelectTab(tag):
            switch (state.selectedTab, tag) {
            case (0, 0):
                state.gallery?.selectedCategory = nil
                state.gallery?.selectedSearchResult = nil
                state.gallery?.selectedItem = nil
            case (1, 1):
                state.library?.selectedCategory = nil
                state.library?.selectedSearchResult = nil
            default:
                break
            }
            state.selectedTab = tag
            return .none
            
        case .gallery(_):
            return .none
    
        }
    }
)
