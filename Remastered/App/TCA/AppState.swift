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
}

extension AppState {
    
    static var previewState: Self {
        AppState(
            library: LibraryState(
                categories: LibraryRowModel.exampleCategories
            ),
            gallery: GalleryState(
                galleryRowModels: GalleryRowModel.exampleRowModels
            )
        )
    }
}
