//
//  GalleryState.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import Foundation
import IdentifiedCollections
import ComposableArchitecture

struct GalleryState: Equatable {
    var categories: IdentifiedArrayOf<LibraryCategoryState> = []
    var selectedCategory: Identified<LibraryCategoryState.ID, LibraryCategoryState>?
    var searchResults: IdentifiedArrayOf<LibraryItemState> = []
    var selectedSearchResult: Identified<LibraryItemState.ID, LibraryItemState>?
    var selectedItem: Identified<LibraryItemState.ID, LibraryItemState>?
    @BindableState var searchText: String = ""
}
