//
//  GalleryEnvironment.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import Foundation
import CombineSchedulers
import ComposableArchitecture

struct GalleryEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fetch: () -> Effect<[LibraryAlbum], Never>
}
