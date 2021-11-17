//
//  FavoritesEnvironment.swift
//  Remastered
//
//  Created by martin on 14.11.21.
//

import ComposableArchitecture
import CombineSchedulers

struct FavoritesEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue> = .main
    var fetch: () -> Effect<[LibraryAlbum], Never>
    var delete: (String) -> Effect<Void, Error>
    var save: (String, Int) -> Effect<Void, Error>
}
