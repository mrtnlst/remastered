//
//  AppAction.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

enum AppAction: Equatable {
    case authorize
    case authorizationResponse(Result<Bool, AuthorizationError>)
}

