//
//  LibraryService.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Combine
import ComposableArchitecture

enum LibraryError: Error {
    case permissionError
}

final class LibraryService {
    
    func fetch() -> Effect<[LibraryAlbum], LibraryError> {
        Future { promise in
            promise(.success(LibraryAlbum.exampleAlbums))
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
        
    }
}
