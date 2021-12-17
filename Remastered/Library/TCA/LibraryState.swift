//
//  LibraryState.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation
import IdentifiedCollections
import ComposableArchitecture

struct LibraryState: Equatable {
    var categories: IdentifiedArrayOf<LibraryCategoryState> = []
    var selectedCategory: Identified<LibraryCategoryState.ID, LibraryCategoryState>?
    var searchResults: IdentifiedArrayOf<LibraryItemState> = []
    var selectedSearchResult: Identified<LibraryItemState.ID, LibraryItemState>?
    @BindableState var searchText: String = ""
}
