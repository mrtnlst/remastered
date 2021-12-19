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
    searchReducer
        .optional()
        .pullback(
            state: \.search,
            action: /AppAction.search,
            environment: {
                SearchEnvironment(
                    mainQueue: $0.mainQueue,
                    fetch: $0.libraryService.fetch,
                    uuid: { UUID.init() }
                )
            }
    ),
    playbackReducer
        .optional()
        .pullback(
            state: \.playback,
            action: /AppAction.playback,
            environment: {
                PlaybackEnvironment(
                    mainQueue: $0.mainQueue,
                    nowPlayingItem: $0.playbackService.nowPlayingItem,
                    playbackProperties: $0.playbackService.playbackProperties,
                    togglePlayback: $0.playbackService.togglePlayback,
                    forward: $0.playbackService.forward
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
            state.search = SearchState()
            state.playback = PlaybackState()
            state.isAuthorized = true
            return Effect(value: .fetch)

        case .authorizationResponse(.success(false)),
                .authorizationResponse(.failure(_)):
            state.library = nil
            state.gallery = nil
            state.search = nil
            state.playback = nil
            state.isAuthorized = false
            return .none
            
        case let .library(.libraryCategory(action: .libraryItem(id: _, action: .didSelectItem(id, type, position)))),
            let .gallery(.libraryCategory(action: .libraryItem(id: _, action: .didSelectItem(id, type, position)))),
            let .library(.libraryItem(action: .didSelectItem(id, type, position))),
            let .gallery(.libraryItem(action: .didSelectItem(id, type, position))),
            let .search(.libraryItem(action: .didSelectItem(id, type, position))):
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
                Effect(value: .gallery(.receiveCollections(result: .success(collections)))),
                Effect(value: .search(.receiveCollections(result: .success(collections))))
            )
            
        case let .didSelectTab(tag):
            switch (state.selectedTab, tag) {
            case (0, 0):
                state.gallery?.selectedCategory = nil
                state.gallery?.selectedItem = nil
            case (1, 1):
                state.library?.selectedCategory = nil
            case (2, 2):
                state.search?.selectedItem = nil
            default:
                break
            }
            state.selectedTab = tag
            return .none
            
        case .binding(\.$tabBarOffset),
             .binding(\.$tabBarHeight):
            let offset = state.tabBarOffset
            let height = state.tabBarHeight
            state.playback?.tabBarOffset = offset
            state.playback?.tabBarHeight = height
            return .none
            
        case .playback(_):
            return .none
            
        case .gallery(_):
            return .none
        
        case .search(_):
            return .none
            
        case .binding:
            return .none
        }
    }
        .binding()
)
