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
            
        case let .library(.libraryCategory(id: _, action: .libraryItem(id: _, action: .didSelectItem(id, type, position)))),
            let .gallery(.libraryCategory(id: _, action: .libraryItem(id: _, action: .didSelectItem(id, type, position)))),
            let .library(.libraryItem(id: _, action: .didSelectItem(id, type, position))),
            let .gallery(.libraryItem(id: _, action: .didSelectItem(id, type, position))):
            return environment
                .playbackService
                .play(id: id, of: type, from: position)
                .subscribe(on: environment.mainQueue)
                .fireAndForget()
         
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
                if let id = state.gallery?.categories.first(where: { $0.isActive })?.id {
                    return .init(
                        value: .gallery(.libraryCategory(id: id, action: .setIsActive(false)))
                    )
                }
                var effect: Effect<AppAction, Never>?
                for categoryState in state.gallery?.categories ?? [] {
                    if let item = categoryState.items.first(where: { $0.isActive }) {
                        effect = Effect(value: .gallery(.libraryCategory(id: categoryState.id, action: .libraryItem(id: item.id, action: .setIsActive(false)))))
                    }
                }
                if let effect = effect {
                    return effect
                }
                
                if let id = state.gallery?.searchResults.first(where: { $0.isActive })?.id {
                    return .init(
                        value: .gallery(.libraryItem(id: id, action: .setIsActive(false)))
                    )
                }
            case (1, 1):
                if let id = state.library?.categories.first(where: { $0.isActive })?.id {
                    return .init(
                        value: .library(.libraryCategory(id: id, action: .setIsActive(false)))
                    )
                }
                if let id = state.library?.searchResults.first(where: { $0.isActive })?.id {
                    return .init(
                        value: .library(.libraryItem(id: id, action: .setIsActive(false)))
                    )
                }
            default:
                break
            }
            state.selectedTab = tag
            return .none
            
        case .gallery(_):
            return .none
    
        case .library(_):
            return .none
        }
    }
)
