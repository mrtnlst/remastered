//
//  MockLibraryService.swift
//  RemasteredTests
//
//  Created by martin on 17.11.21.
//

import ComposableArchitecture
@testable import Remastered

final class MockLibraryService: LibraryService {
    private var mockFetch: () -> Effect<[LibraryAlbum], Never>
    
    init(mockFetch: @escaping () -> Effect<[LibraryAlbum], Never>) {
        self.mockFetch = mockFetch
    }
    
    func fetch() -> Effect<[LibraryAlbum], Never> {
        return mockFetch()
    }
}
