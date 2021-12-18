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
    var selectedItem: Identified<LibraryItemState.ID, LibraryItemState>?
}
