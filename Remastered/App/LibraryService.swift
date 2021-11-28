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
    func fetchLibraryItems() -> Effect<[LibraryRowModel], Never>
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
    
    func fetchLibraryItems() -> Effect<[LibraryRowModel], Never> {
        Future { promise in
            self.fetch()
                .sink { items in
                    var models: [LibraryRowModel] = []
                    LibraryRowModel.RowType.allCases.forEach { type in
                        let model = LibraryRowModel(
                            type: type,
                            items: items
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
}
private extension LibraryService{
    /// Fetches all library media items and returns an effect.
    /// - Returns: Returns an array of media items. When it fails, an empty array is returned.
    func fetch() -> Effect<[LibraryCollection], Never> {
        Future { promise in
            #if targetEnvironment(simulator)
            promise(.success(LibraryCollection.exampleAlbums))
            #else
            let collections = MPMediaQuery.albums().collections
            let albums = collections?.compactMap {
                LibraryCollection(with: $0)
            }
            promise(.success(albums ?? []))
            #endif
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
}
