//
//  DefaultLibraryService.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

protocol LibraryService {
    func fetch(type: LibraryServiceResult) -> Effect<LibraryServiceResult, Never>
    func fetchCollection(for id: String, of type: LibraryServiceResult) -> Effect<LibraryServiceResult, Never>
}
