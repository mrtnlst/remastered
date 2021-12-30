//
//  AuthorizationService.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import MediaPlayer
import ComposableArchitecture
import Combine

enum AuthorizationError: Error {
    case authorizationFailed
}

protocol AuthorizationService {
    func authorize() -> Effect<Bool, AuthorizationError>
}

final class DefaultAuthorizationService: AuthorizationService {
    
    func authorize() -> Effect<Bool, AuthorizationError> {
#if targetEnvironment(simulator)
        return Future { $0(.success(true)) }.eraseToAnyPublisher().eraseToEffect()
#else
        Future { promise in
            let status = MPMediaLibrary.authorizationStatus()
            
            switch status {
            case .authorized:
                promise(.success(true))
                
            case .notDetermined:
                MPMediaLibrary.requestAuthorization() { status in
                    if status == .authorized {
                        promise(.success(true))
                    } else {
                        promise(.failure(.authorizationFailed))
                    }
                }
            default:
                promise(.failure(.authorizationFailed))
            }
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
#endif
    }
}
