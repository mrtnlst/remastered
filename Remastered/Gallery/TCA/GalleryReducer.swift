//
//  GalleryReducer.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import ComposableArchitecture

let galleryReducer = Reducer<GalleryState, GalleryAction, GalleryEnvironment> { state, action, environment in
    switch action {
    case .fetch:
        return environment
            .fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(GalleryAction.receiveCollections)
        
    case let .receiveCollections(.success(collections)):
        var models: [GalleryRowModel] = []
        
        GalleryRowModel.RowType.allCases.forEach { type in
            let items = collections
                .filter(type.filterValue)
                .sorted(by: type.sortOrder)
            guard !items.isEmpty else { return }
            
            let model = GalleryRowModel(
                id: environment.uuid(),
                items: Array(items.prefix(10)),
                type: type
            )
            models.append(model)
        }
        state.galleryRowModels = models
        return .none
    
    case let .didSelectItem(id, type):
        return .none
    }
}
