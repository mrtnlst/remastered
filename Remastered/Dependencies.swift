//
//  Dependencies.swift
//  Remastered
//
//  Created by martin on 14.11.21.
//

import Foundation
import ComposableArchitecture

struct Dependencies {
    
    var authorize: () -> Effect<Bool, AuthorizationError>
    var fetch: () -> Effect<[LibraryAlbum], Never>
    
    init() {
        let authorizationService = AuthorizationService()
        authorize = {
            authorizationService.authorize()
        }
        
        let libraryService = LibraryService()
        fetch = {
            libraryService.fetch()
        }
    }
}
