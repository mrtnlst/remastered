//
//  RemasteredApp.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import SwiftUI
import ComposableArchitecture

@main
struct RemasteredApp: App {
    
    static var store = Store(
        initialState: AppState(favorites: FavoritesState()),
        reducer: appReducer,
        environment: AppEnvironment(
            libraryService: DefaultLibraryService(),
            authorizationService: DefaultAuthorizationService(),
            favoritesService: DefaultFavoritesService()
        )
    )
    
    var body: some Scene {
        WindowGroup {
            AppView(store: Self.store)
        }
    }
}
