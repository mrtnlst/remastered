//
//  MockFavoritesRepository.swift
//  RemasteredTests
//
//  Created by martin on 17.11.21.
//

import ComposableArchitecture
@testable import Remastered

final class MockFavoritesRepository: Repository {
    private var mockFetch: () -> Effect<[LibraryAlbum], Never>
    private var mockDelete: (String) -> Effect<Void, Error>
    private var mockSave: (String, Int) -> Effect<Void, Error>
    
    static let mockFavorites: [LibraryAlbum] = [
        LibraryAlbum(title: "Organ", artist: "Dimension", id: "AABB-CCDD-EEFF-GGHH", position: 0),
        LibraryAlbum(title: "Whenever You Need Somebody", artist: "Rick Astley", id: "AABB-CCDD-EEFF-KKLL", position: 1),
    ]
    
    init(
        mockFetch: @escaping () -> Effect<[LibraryAlbum], Never>,
        mockDelete: @escaping (String) -> Effect<Void, Error>,
        mockSave: @escaping (String, Int) -> Effect<Void, Error>
    ) {
        self.mockFetch = mockFetch
        self.mockSave = mockSave
        self.mockDelete = mockDelete
    }
    
    func fetch() -> Effect<[LibraryAlbum], Never> {
        return mockFetch()
    }
    
    func save(id: String, position: Int) -> Effect<Void, Error> {
        return mockSave(id, position)
    }
    
    func delete(id: String) -> Effect<Void, Error> {
        return mockDelete(id)
    }
}
