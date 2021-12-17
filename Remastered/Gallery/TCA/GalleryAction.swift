//
//  GalleryAction.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import Foundation
import ComposableArchitecture

enum GalleryAction: Equatable, BindableAction {
    case fetch
    case receiveCollections(result: Result<[LibraryCollection], Never>)
    case libraryCategory(action: LibraryCategoryAction)
    case libraryItem(action: LibraryItemAction)
    case binding(BindingAction<GalleryState>)
    case setCategoryNavigation(selection: UUID?)
    case setSearchResultNavigation(selection: UUID?)
    case setItemNavigation(selection: UUID?)
}
