//
//  AppReducer.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
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
    }
    return .none
}
