//
//  GalleryCategoryReducer.swift
//  Remastered
//
//  Created by martin on 05.12.21.
//

import ComposableArchitecture

let galleryCategoryReducer = Reducer<GalleryCategoryState, GalleryCategoryAction, GalleryCategoryEnvironment> {
    state, action, environment in
    switch action {
    case .libraryItem(_, _):
        return .none
    }
}
