//
//  SearchEnvironment.swift
//  Remastered
//
//  Created by martin on 18.12.21.
//

import CombineSchedulers
import ComposableArchitecture

struct SearchEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fetch: () -> Effect<[LibraryCollection], Never>
    var uuid: () -> UUID
}
