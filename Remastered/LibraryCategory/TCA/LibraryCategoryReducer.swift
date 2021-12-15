//
//  LibraryCategoryReducer.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import ComposableArchitecture

let libraryCategoryReducer = Reducer<LibraryCategoryState, LibraryCategoryAction, LibraryCategoryEnvironment>.combine(
    libraryItemReducer.forEach(
        state: \.items,
        action: /LibraryCategoryAction.libraryItem(id:action:),
        environment: { _ in LibraryItemEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        case let .setIsActive(isActive):
            state.isActive = isActive
            return .none
            
        case .binding:
            return .none
            
        case .libraryItem(_, _):
            return .none
        }
    }
        .binding()
)
