//
//  GalleryService.swift
//  Remastered
//
//  Created by martin on 08.01.22.
//

import ComposableArchitecture

protocol GalleryService {
    func fetch(type: GalleryServiceResult) -> Effect<GalleryServiceResult, Never>
}

