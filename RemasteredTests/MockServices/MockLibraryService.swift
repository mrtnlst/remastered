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
