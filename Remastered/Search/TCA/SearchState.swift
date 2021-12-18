//
//  SearchState.swift
//  Remastered
//
//  Created by martin on 18.12.21.
//

import ComposableArchitecture
import IdentifiedCollections

struct SearchState: Equatable {
    var collections: [LibraryCollection] = []
    var searchResults: IdentifiedArrayOf<LibraryItemState> = []
    var selectedItem: Identified<LibraryItemState.ID, LibraryItemState>?
    @BindableState var searchText: String = ""
}



