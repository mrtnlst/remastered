//
//  AppEnvironment.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation
import CombineSchedulers
import ComposableArchitecture

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue> = .main
    var libraryService: LibraryService
    var galleryService: GalleryService
    var authorizationService: AuthorizationService
    var playbackService: PlaybackService
}

