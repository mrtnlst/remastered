//
//  LibraryEnvironment.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation
import CombineSchedulers
import ComposableArchitecture

struct LibraryEnvironment {
    var fetch: (LibraryServiceResult) -> Effect<LibraryServiceResult, Never>
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}
