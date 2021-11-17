//
//  DefaultFavoritesRepository.swift
//  Remastered
//
//  Created by martin on 17.11.21.
//


import CoreData
import Combine
import ComposableArchitecture

protocol Repository {
    func fetch() -> Effect<[LibraryAlbum], Never>
    func save(id: String, position: Int) -> Effect<Void, Error>
    func delete(id: String) -> Effect<Void, Error>
}

final class DefaultFavoritesRepository: Repository {
    
    lazy var context: NSManagedObjectContext = { return persistentContainer.viewContext }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    func fetch() -> Effect<[LibraryAlbum], Never> {
        let context = self.context
        return Future { promise in
            let favorites = try? context.fetch(FavoriteAlbum.fetchRequest())
            let albums = (favorites ?? []).compactMap { favorite -> LibraryAlbum? in
                var album = LibraryAlbum.exampleAlbums.first { $0.id == favorite.id }
                album?.position = Int(favorite.position)
                return album
            }
            promise(.success(albums))
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }

    public func save(id: String, position: Int) -> Effect<Void, Error> {
        let context = self.context
        return Effect<Void, Error>.result { [context] () -> Result<Void, Error> in
            Result<Void, Error> {
                let model = FavoriteAlbum(context: context)
                model.id = id
                model.position = Int16(position)
                try context.save()
            }
        }
    }

    public func delete(id: String) -> Effect<Void, Error> {
        let context = self.context
        return Effect<Void, Error>.result { [context] () -> Result<Void, Error> in
            Result<Void, Error> {
                var result = try? context.fetch(FavoriteAlbum.fetchRequest())
                
                for object in (result ?? []) where object.id == id {
                    context.delete(object)
                    result?.removeAll(where: { $0.id == object.id })
                }
                
                // Rewrites the position of all remaining favorites, otherwise unique positions cannot be guaranteed.
                result?.sort(by: { $0.position < $1.position })
                
                for (index, item) in (result ?? []).enumerated() {
                    item.position = Int16(index)
                }
                try context.save()
            }
        }
    }
}
