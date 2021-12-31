//
//  AppReducer.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture
import UIKit

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
            environment: { env in
                PlaybackEnvironment(
                    mainQueue: env.mainQueue,
                    playbackProperties: env.playbackService.playbackProperties,
                    togglePlayback: env.playbackService.togglePlayback,
                    toggleShuffle: env.playbackService.toggleShuffle,
                    toggleRepeat: env.playbackService.toggleRepeat,
                    forward: env.playbackService.forward,
                    backward: env.playbackService.backward
                )
            }
        ),
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
#if targetEnvironment(simulator)
            return Effect(value: .didBecomeActive)
#else
            return .merge(
                NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
                    .map { _ in .didBecomeActive }
                    .eraseToEffect()
            )
#endif
        case .didBecomeActive:
            return environment
                .authorizationService
                .authorize()
                .receive(on: environment.mainQueue)
                .catchToEffect(AppAction.authorizationResponse)
            
        case .authorizationResponse(.success(true)):
            if !(state.isAuthorized ?? false) {
                state.library = LibraryState(categories: LibraryState.initialCategories)
                state.gallery = GalleryState(rows: GalleryState.initialRows)
                state.search = SearchState()
                state.playback = PlaybackState()
                state.isAuthorized = true
            }
            return Effect(value: .fetch)
            
        case .authorizationResponse(.success(false)),
             .authorizationResponse(.failure(_)):
            state.library = nil
            state.gallery = nil
            state.search = nil
            state.playback = nil
            state.isAuthorized = false
            return .none
            
        case let .library(.libraryCategory(action: .libraryItem(id: _, action: .didSelectItem(id, type, startItem)))),
            let .gallery(.galleryRowAction(id: _, action: .libraryCategory(action: .libraryItem(id: _, action: .didSelectItem(id, type, startItem))))),
            let .gallery(.galleryRowAction(id: _, action: .libraryItem(action: .didSelectItem(id, type, startItem)))),
            let .search(.libraryItem(action: .didSelectItem(id, type, startItem))):
            return environment
                .playbackService
                .play(id: id, of: type, with: startItem)
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
            var effects: [Effect<AppAction, Never>] = []
            switch (state.selectedTab, tag) {
            case (0, 0):
                effects.append(Effect(value: .gallery(.dismiss)))
            case (1, 1):
                state.library?.selectedCategory = nil
            case (2, 2):
                state.search?.selectedItem = nil
            default:
                break
            }
            state.selectedTab = tag
            return .merge(effects)
            
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
