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
                    fetch: $0.libraryService.fetch,
                    mainQueue: $0.mainQueue,
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
                    uuid: { UUID.init() },
                    fetch: $0.galleryService.fetch
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
            return .none
            
        case .authorizationResponse(.success(false)),
             .authorizationResponse(.failure(_)):
            state.library = nil
            state.gallery = nil
            state.search = nil
            state.playback = nil
            state.isAuthorized = false
            return .none
            
        case let .library(.libraryCategory(.libraryItem(_, action: .didSelectItem(id, type, startItem)))),
            let .library(.libraryItem(.didSelectItem(id, type, startItem))),
            let .gallery(.libraryItem(.didSelectItem(id, type, startItem))),
            let .gallery(.galleryRowAction(_, action: .libraryCategory(.libraryItem(_, action: .didSelectItem(id, type, startItem))))),
            let .gallery(.galleryRowAction(_, action: .libraryItem(.didSelectItem(id, type, startItem)))),
            let .search(.libraryItem(.didSelectItem(id, type, startItem))):
            return environment
                .playbackService
                .play(id: id, of: type, with: startItem)
                .subscribe(on: environment.mainQueue)
                .fireAndForget()
            
        case .library(_):
            return .none
            
        case let .didSelectTab(tag):
            var effects: [Effect<AppAction, Never>] = []
            switch (state.selectedTab, tag) {
            case (0, 0):
                effects.append(Effect(value: .gallery(.dismiss)))
            case (1, 1):
                effects.append(Effect(value: .library(.dismiss)))
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
            
        case let .playback(.openItemView(persistentId, type)):
            if let persistentId = persistentId {
                return environment
                    .libraryService
                    .fetchCollection(for: persistentId, of: type.serviceResult)
                    .catchToEffect(AppAction.fetchCollectionResponse)
            }
            return .none
            
        case let .fetchCollectionResponse(.success(result)):
            let collection = result.collections.first
            switch state.selectedTab {
            case 0:
                return .concatenate(
                    Effect(value: .gallery(.dismiss)),
                    Effect(value: .gallery(.openCollection(collection)))
                    // Introduces a delay, so that the dismissal of the navigation stack runs smoothly.
                        .delay(for: 0.55, scheduler: environment.mainQueue)
                        .eraseToEffect()
                )
            case 1:
                return .concatenate(
                    Effect(value: .library(.dismiss)),
                    Effect(value: .library(.openCollection(collection)))
                    // Introduces a delay, so that the dismissal of the navigation stack runs smoothly.
                        .delay(for: 0.55, scheduler: environment.mainQueue)
                        .eraseToEffect()
                )
            case 2:
                state.search?.selectedItem = nil
                return Effect(value: .search(.setItemNavigation(selection: collection?.id)))
            default:
                return .none
            }
            
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
