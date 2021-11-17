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
        
    case let .saveFavorite(id):
        guard !state.favorites.contains(where: { $0.id == id }) else {
            return environment
                .delete(id)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map { _ in FavoritesAction.fetchFavorites }
        }
        return environment
            .save(id, state.favorites.count)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map { _ in FavoritesAction.fetchFavorites }
    }
}
