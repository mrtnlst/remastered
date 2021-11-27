//
//  AppState.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

struct AppState: Equatable {
    var library: LibraryState?
}

extension AppState {
    
    static var previewState: Self {
        AppState(
            library: LibraryState(
                albums: LibraryAlbum.exampleAlbums
            )
        )
    }
}
