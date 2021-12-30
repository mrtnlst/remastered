//
//  GalleryRowState.swift
//  Remastered
//
//  Created by martin on 25.12.21.
//

import ComposableArchitecture

struct GalleryRowState: Equatable, Identifiable {
    let id: UUID
    var category: LibraryCategoryState
    var selectedCategory: Identified<LibraryCategoryState.ID, LibraryCategoryState>?
    var selectedItem: Identified<LibraryItemState.ID, LibraryItemState>?
}
