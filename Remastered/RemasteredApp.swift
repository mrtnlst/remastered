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
    
    let store = Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
            authorizationService: AuthorizationService(),
            libraryService: LibraryService()
        )
    )
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
