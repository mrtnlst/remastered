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
        // TODO: Not very good
        state.albums = albums
        for (index, favorite) in state.favorites.enumerated() {
            if let albumIndex = state.albums.firstIndex(where: { $0.id == favorite.id }) {
                state.albums[albumIndex].position = favorite.position
            }
        }
        return .none
        
    case let .libraryAlbumSelected(id):
        // TODO: Not very good
        for (index, favorite) in state.albums.enumerated() {
            let album = state.albums[index]
            if album.id == id {
                state.albums[index].position = album.isFavorite ? nil : 0
            }
        }
        return .none
        
    case let .receiveFavoriteAlbums(favorites):
        state.favorites = favorites
        return .none
    }
}
