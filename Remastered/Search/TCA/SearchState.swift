//
//  SearchState.swift
//  Remastered
//
//  Created by martin on 18.12.21.
//

import ComposableArchitecture
import IdentifiedCollections

struct SearchState: Equatable {
    struct Section: Identifiable, Equatable {
        var id: UUID { type.uuid }
        let type: LibraryCategoryType
        var items: IdentifiedArrayOf<LibraryItemState> = []
    }
    var collections: [LibraryCollection] = []
    var searchSections: IdentifiedArrayOf<Section> = []
    var selectedItem: Identified<LibraryItemState.ID, LibraryItemState>?
    @BindableState var searchText: String = ""
    let emptyNavigationLinkId: UUID = UUID(uuidString: "5E6A0452-25ED-4F2C-8E70-3BB02CC4CEBC")!
}

extension SearchState {
    static var previewSections: IdentifiedArrayOf<SearchState.Section> = .init(
        uniqueElements: [
            SearchState.Section(
                type: .album,
                items: LibraryCategoryState.exampleLibraryAlbums
            ),
            SearchState.Section(
                type: .playlist,
                items: LibraryCategoryState.exampleLibraryPlaylists
            ),
            SearchState.Section(
                type: .artist,
                items: LibraryCategoryState.exampleLibraryArtists
            )
        ]
    )
}
