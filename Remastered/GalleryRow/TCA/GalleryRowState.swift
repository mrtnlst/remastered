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

enum GalleryRowAction: Equatable {
    case libraryCategory(action: LibraryCategoryAction)
    case libraryItem(action: LibraryItemAction)
    case setCategoryNavigation(selection: UUID?)
    case setItemNavigation(selection: UUID?)
    case receiveCategory(LibraryCategoryState)
    case dismiss
}

struct GalleryRowEnvironment {}

let galleryRowReducer = Reducer<GalleryRowState, GalleryRowAction, GalleryRowEnvironment> { state, action, _ in
    switch action {
    case let .setCategoryNavigation(id):
        guard let id = id else {
            state.selectedCategory = nil
            return .none
        }
        state.selectedCategory = Identified(state.category, id: id)
        return .none
        
    case let .setItemNavigation(id):
        guard let id = id else {
            state.selectedItem = nil
            return .none
        }
        if let item = state.category.items.first(where: { $0.id == id }) {
            state.selectedItem = Identified(item, id: id)
        }
        return .none
        
    case let .receiveCategory(category):
        state.category = category
        return .none
    
    case .dismiss:
        state.selectedCategory = nil
        state.selectedItem = nil
        return .none
        
    case .libraryCategory(_):
        return .none
        
    case .libraryItem(_):
        return .none
    }
    
}
