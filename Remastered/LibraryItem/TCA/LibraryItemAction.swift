//
//  LibraryItemAction.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation
import ComposableArchitecture

enum LibraryItemAction: Equatable, BindableAction {
    case didSelectItem(id: String, type: LibraryCategoryType, position: Int? = nil)
    case binding(BindingAction<LibraryItemState>)
    case setIsActive(_ isActive: Bool)
}
