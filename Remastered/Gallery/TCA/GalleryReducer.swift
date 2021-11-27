//
//  GalleryReducer.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import ComposableArchitecture

let galleryReducer = Reducer<GalleryState, GalleryAction, GalleryEnvironment> { state, action, environment in
    switch action {
    case .fetchAlbums:
        return environment
            .fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(GalleryAction.receiveAlbums)
        
    case let .receiveAlbums(.success(albums)):
        state.galleryRowModels.removeAll()
        GalleryRowModel.RowType.allCases.forEach { type in
            let items = albums
                .filter(type.filterValue)
                .sorted(by: type.sortOrder)
            
            let model = GalleryRowModel(
                items: Array(items.prefix(10)),
                type: type
            )
            state.galleryRowModels.append(model)
        }
        return .none
    
    case let .didSelectItem(id):
        return .none
    }
}
