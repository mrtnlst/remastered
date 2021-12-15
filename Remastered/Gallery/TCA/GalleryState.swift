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
    var searchResults: IdentifiedArrayOf<LibraryItemState> = []
    @BindableState var searchText: String = ""
}
