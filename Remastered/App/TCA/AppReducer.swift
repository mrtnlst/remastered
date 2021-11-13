//
//  AppReducer.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    libraryReducer.pullback(
        state: \.library,
        action: /AppAction.library,
        environment: { LibraryEnvironment(libraryService: $0.libraryService) }
    ),
    Reducer { state, action, environment in
        switch action {
        case .authorize:
            return environment
                .authorizationService
                .authorize()
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(AppAction.authorizationResponse)
            
        case .authorizationResponse(.success(true)):
            state.isAuthorized = true
            
        case .authorizationResponse(.success(false)),
                .authorizationResponse(.failure(_)):
            state.isAuthorized = false
            
        case .library(_):
            return .none
        }
        return .none
    }
)
