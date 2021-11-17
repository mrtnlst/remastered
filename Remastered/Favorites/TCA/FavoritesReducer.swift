//
//  FavoritesReducer.swift
//  Remastered
//
//  Created by martin on 14.11.21.
//

import ComposableArchitecture

let favoritesReducer = Reducer<
    FavoritesState,
    FavoritesAction,
    FavoritesEnvironment
> { state, action, environment in
    switch action {
    case .fetchFavorites:
        return environment
            .fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(FavoritesAction.receiveFavorites)
    
    case let .receiveFavorites(.success(favorites)):
        state.favorites = favorites.sorted { $0.position ?? Int.max < $1.position ?? Int.max }
        return .none
    }
}
