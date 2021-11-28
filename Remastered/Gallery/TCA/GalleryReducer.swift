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
            .catchToEffect(GalleryAction.receiveGalleryItems)
        
    case let .receiveGalleryItems(.success(items)):
        state.galleryRowModels = items
        return .none
    
    case let .didSelectItem(id):
        return .none
    }
}
