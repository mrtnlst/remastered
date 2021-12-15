//
//  LibraryCategoryAction.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation
import ComposableArchitecture

enum LibraryCategoryAction: Equatable, BindableAction {
    case libraryItem(id: UUID, action: LibraryItemAction)
    case binding(BindingAction<LibraryCategoryState>)
    case setIsActive(_ isActive: Bool)
}
