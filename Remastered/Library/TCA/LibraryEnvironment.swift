//
//  LibraryEnvironment.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation
import ComposableArchitecture

struct LibraryEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fetch: () -> Effect<[LibraryAlbum], Never>
}
