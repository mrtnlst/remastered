//
//  LibraryService.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Combine
import ComposableArchitecture
import MediaPlayer

protocol LibraryService {
    func fetch() -> Effect<[LibraryAlbum], Never>
}

final class DefaultLibraryService: LibraryService {
    
    func fetch() -> Effect<[LibraryAlbum], Never> {
        Future { promise in
            #if targetEnvironment(simulator)
            promise(.success(LibraryAlbum.exampleAlbums))
            #else
            let collections = MPMediaQuery.albums().collections
            let albums = collections?.compactMap {
                LibraryAlbum(with: $0)
            }
            promise(.success(albums ?? []))
            #endif
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
        
    }
}
