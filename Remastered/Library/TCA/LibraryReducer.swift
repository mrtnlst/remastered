//
//  LibraryReducer.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

let libraryReducer = Reducer<LibraryState, LibraryAction, LibraryEnvironment> { state, action, environment in
    switch action {
    case .fetch:
        return environment
            .fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(LibraryAction.receiveLibraryItems)
        
    case let .receiveLibraryItems(.success(items)):
        state.libraryRowModels = items
        return .none
        
    case let .didSelectItem(id):
        return .none
        
    }
}
