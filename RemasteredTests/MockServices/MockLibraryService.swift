//
//  MockLibraryService.swift
//  RemasteredTests
//
//  Created by martin on 17.11.21.
//

import ComposableArchitecture
@testable import Remastered

final class MockLibraryService: LibraryService {
    private var mockFetch: () -> Effect<[LibraryCollection], Never>
    private var mockFetchCollection: (String, LibraryCategoryType) -> Effect<LibraryCollection?, Never>
    
    init(
        mockFetch: @escaping () -> Effect<[LibraryCollection], Never>,
        mockFetchCollection: @escaping (String, LibraryCategoryType) -> Effect<LibraryCollection?, Never>
    ) {
        self.mockFetch = mockFetch
        self.mockFetchCollection = mockFetchCollection
    }
    
    func fetch() -> Effect<[LibraryCollection], Never> {
        return self.mockFetch()
    }
    
    func fetchCollection(for id: String, of type: LibraryCategoryType) -> Effect<LibraryCollection?, Never> {
        return self.mockFetchCollection(id, type)
    }
}
