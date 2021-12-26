//
//  AppState.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture
import CoreGraphics

struct AppState: Equatable {
    var library: LibraryState?
    var gallery: GalleryState?
    var search: SearchState?
    var playback: PlaybackState?
    
    /// The optional state indicates that the authorization process is currently in progress.
    var isAuthorized: Bool?
    /// The selected tab is observed to catch double taps on a single tab item.
    var selectedTab: Int = 0
    /// We observe the tab bar height and propagate it to the dedicated state.
    @BindableState var tabBarHeight: CGFloat = 0
    /// We observe the tab bar offset and propagate it to the dedicated state.
    @BindableState var tabBarOffset: CGFloat = 0
}

extension AppState {
    
    static var previewState: Self {
        AppState(
            library: LibraryState(
                categories: LibraryCategoryState.exampleLibraryCategories
            ),
            gallery: GalleryState(
                rows: GalleryState.initialRows
            ),
            search: SearchState(
                collections: LibraryCollection.exampleAlbums
            ),
            isAuthorized: true
        )
    }
}
