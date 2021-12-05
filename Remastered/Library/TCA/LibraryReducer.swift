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
                    items: .init(uniqueElements: itemStates),
                    type: type,
                    id: environment.uuid()
                  )
                  state.categories.updateOrAppend(category)
              }
              return .none
              
          case .libraryCategory(_, _):
              return .none
          }
      }
)
