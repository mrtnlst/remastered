//
//  LibraryReducer.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

let libraryReducer = Reducer<LibraryState, LibraryAction, LibraryEnvironment>.combine(
      libraryCategoryReducer.forEach(
        state: \.categories,
        action: /LibraryAction.libraryCategory(id:action:),
        environment: { _ in LibraryCategoryEnvironment() }
      ),
      libraryItemReducer.forEach(
        state: \.searchResults,
        action: /LibraryAction.libraryItem(id:action:),
        environment: { _ in LibraryItemEnvironment() }
      ),
      Reducer { state, action, environment in
          switch action {
          case .fetch:
              return environment
                  .fetch()
                  .receive(on: environment.mainQueue)
                  .catchToEffect(LibraryAction.receiveCollections)
              
          case let .receiveCollections(.success(collections)):
              LibraryCategoryType.allCases.forEach { type in
                  let filteredCollections = collections.filter { $0.type == type }
                  guard !filteredCollections.isEmpty else { return }
                  
                  let itemStates: [LibraryItemState] = filteredCollections.map { collection in
                      LibraryItemState(
                        item: collection,
                        id: environment.uuid()
                      )
                  }
                  let category = LibraryCategoryState(
                    id: environment.uuid(),
                    items: .init(uniqueElements: itemStates),
                    name: type.rawValue,
                    icon: type.icon
                    
                  )
                  state.categories.updateOrAppend(category)
              }
              return .none

          case .binding(\.$searchText):
              guard !state.searchText.isEmpty else {
                  state.searchResults = []
                  return .none
              }
              let items = state.categories.map( { $0.items }).reduce([], +)
              let result = items.filter {
                  $0.item.title.lowercased().contains(state.searchText.lowercased()) ||
                  $0.item.subtitle.lowercased().contains(state.searchText.lowercased())
              }
              state.searchResults = IdentifiedArrayOf<LibraryItemState>(uniqueElements: result)
              return .none
              
          case .binding:
              return .none
              
          case .libraryCategory(_, _):
              return .none
          
          case .libraryItem(_, _):
              return .none
          }
      }
        .binding()
)
