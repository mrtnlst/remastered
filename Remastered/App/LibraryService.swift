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
    func fetchLibraryItems() -> Effect<[LibraryCategoryModel], Never>
    func fetchGalleryItems() -> Effect<[GalleryRowModel], Never>
}

final class DefaultLibraryService: LibraryService {
    var cancellables = Set<AnyCancellable>()
 
    func fetchGalleryItems() -> Effect<[GalleryRowModel], Never> {
        Future { promise in
            self.fetch()
                .sink { items in
                    var models: [GalleryRowModel] = []
                    GalleryRowModel.RowType.allCases.forEach { type in
                        let items = items
                            .filter(type.filterValue)
                            .sorted(by: type.sortOrder)
                        
                        let model = GalleryRowModel(
                            items: Array(items.prefix(10)),
                            type: type
                        )
                        models.append(model)
                    }
                    promise(.success(models))
                }
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func fetchLibraryItems() -> Effect<[LibraryCategoryModel], Never> {
        Future { promise in
            #if targetEnvironment(simulator)
            let model = LibraryCategoryModel(
                type: .albums,
                items: LibraryCollection.exampleAlbums
            )
            promise(.success([model]))
            #else
            let query = MPMediaQuery()
            query.groupingType = .album
            let model = LibraryCategoryModel(
                type: .albums,
                items: query.collections?.compactMap { $0.toAlbum() } ?? []
            )
            query.groupingType = .playlist
            let model2 = LibraryCategoryModel(
                type: .playlists,
                items: query.collections?.compactMap { $0.toPlaylist() } ?? []
            )
            query.groupingType = .genre
            let model3 = LibraryCategoryModel(
                type: .genres,
                items: query.collections?.compactMap { $0.toGenre() } ?? []
            )
            query.groupingType = .title
            let model4 = LibraryCategoryModel(
                type: .songs,
                items: []
            )
            query.groupingType = .albumArtist
            let model5 = LibraryCategoryModel(
                type: .artists,
                items: query.collections?.compactMap { $0.toArtist() } ?? []
            )
            promise(.success([model, model2, model3, model4, model5]))
            #endif
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
}

private extension LibraryService {
    /// Fetches all library media items and returns an effect.
    /// - Returns: Returns an array of media items. When it fails, an empty array is returned.
    func fetch() -> Effect<[LibraryCollection], Never> {
        Future { promise in
            #if targetEnvironment(simulator)
            promise(.success(LibraryCollection.exampleAlbums))
            #else
            let collections = MPMediaQuery.albums().collections
            let albums = collections?.compactMap { $0.toAlbum() } ?? []
            promise(.success(albums))
            #endif
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
}
