//
//  LibraryItemReducer.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import ComposableArchitecture

let libraryItemReducer = Reducer<LibraryItemState, LibraryItemAction, LibraryItemEnvironment> { state, action, environment in
    switch action {
    case .binding:
        return .none
        
    case .didSelectItem(_, _, _):
        return .none
        
    case let .setIsActive(isActive):
        state.isActive = isActive
        return .none
    }
}
    .binding()
