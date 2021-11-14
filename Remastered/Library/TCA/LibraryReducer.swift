//
//  LibraryReducer.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

let libraryReducer = Reducer<LibraryState, LibraryAction, LibraryEnvironment> { state, action, environment in
    
    switch action {
    case .fetchAlbums:
        return environment
            .fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(LibraryAction.receiveAlbums)
        
    case let .receiveAlbums(.success(albums)):
        state.albums = albums
        return .none
        
    case .starTapped:
        return .none
    }
}
