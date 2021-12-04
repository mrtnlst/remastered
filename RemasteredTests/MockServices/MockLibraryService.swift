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
    
    init(
        mockFetch: @escaping () -> Effect<[LibraryCollection], Never>
    ) {
        self.mockFetch = mockFetch
    }
    
    func fetch() -> Effect<[LibraryCollection], Never> {
        return self.mockFetch()
    }
}
