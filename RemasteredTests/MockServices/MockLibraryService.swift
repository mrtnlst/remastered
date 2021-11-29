//
//  MockLibraryService.swift
//  RemasteredTests
//
//  Created by martin on 17.11.21.
//

import ComposableArchitecture
@testable import Remastered

final class MockLibraryService: LibraryService {
    private var mockFetchLibrary: () -> Effect<[LibraryCategoryModel], Never>
    private var mockFetchGallery: () -> Effect<[GalleryRowModel], Never>
    
    init(
        mockFetchLibrary: @escaping () -> Effect<[LibraryCategoryModel], Never>,
        mockFetchGallery: @escaping () -> Effect<[GalleryRowModel], Never>
    ) {
        self.mockFetchLibrary = mockFetchLibrary
        self.mockFetchGallery = mockFetchGallery
    }
    
    func fetchLibraryItems() -> Effect<[LibraryCategoryModel], Never> {
        return mockFetchLibrary()
    }
    
    func fetchGalleryItems() -> Effect<[GalleryRowModel], Never> {
        return mockFetchGallery()
    }
}
