//
//  MockAuthorizationService.swift
//  RemasteredTests
//
//  Created by martin on 17.11.21.
//

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
