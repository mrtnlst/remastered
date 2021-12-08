//
//  AppState.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

struct AppState: Equatable {
    var library: LibraryState?
    var gallery: GalleryState?
    var isAuthorized: Bool?
}

extension AppState {
    
    static var previewState: Self {
        AppState(
            library: LibraryState(
                categories: LibraryCategoryState.exampleCategories
            ),
            gallery: GalleryState(
                categories: GalleryCategoryState.exampleCategories
            )
        )
    }
}
