//
//  AppAction.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation
import ComposableArchitecture

enum AppAction: Equatable, BindableAction {
    case onAppear
    case authorizationResponse(Result<Bool, AuthorizationError>)
    case fetch
    case fetchResponse(Result<[LibraryCollection], Never>)
    case library(LibraryAction)
    case gallery(GalleryAction)
    case search(SearchAction)
    case playback(PlaybackAction)
    case didSelectTab(_ tag: Int)
    case binding(BindingAction<AppState>)
    case didBecomeActive
}

