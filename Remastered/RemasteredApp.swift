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
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
            libraryService: DefaultLibraryService(),
            authorizationService: DefaultAuthorizationService()
        )
    )
    
    var body: some Scene {
        WindowGroup {
            AppView(store: Self.store)
        }
    }
}
