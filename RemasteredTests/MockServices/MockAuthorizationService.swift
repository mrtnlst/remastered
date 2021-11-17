import ComposableArchitecture
@testable import Remastered

final class MockAuthorizationService: AuthorizationService {
    private var mockAuthorize: () -> Effect<Bool, AuthorizationError>
    
    init(mockAuthorize: @escaping () -> Effect<Bool, AuthorizationError>) {
        self.mockAuthorize = mockAuthorize
    }
    
    func authorize() -> Effect<Bool, AuthorizationError> {
        mockAuthorize()
    }
}
