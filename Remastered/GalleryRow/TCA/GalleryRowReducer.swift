//
//  GallerRowReducer.swift
//  Remastered
//
//  Created by martin on 26.12.21.
//

import Foundation
import ComposableArchitecture

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
