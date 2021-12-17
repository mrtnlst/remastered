//
//  AppAction.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation

enum AppAction: Equatable {
    case onAppear
    case authorizationResponse(Result<Bool, AuthorizationError>)
    case fetch
    case fetchResponse(Result<[LibraryCollection], Never>)
    case library(LibraryAction)
    case gallery(GalleryAction)
    case didSelectTab(_ tag: Int)
}

