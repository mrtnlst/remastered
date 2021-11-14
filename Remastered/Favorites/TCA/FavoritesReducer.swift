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
    case .selected:
        return .none
    }
}
