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
                  .catchToEffect(LibraryAction.receiveLibraryItems)
              
          case let .receiveLibraryItems(.success(items)):
              // TODO: Clean Up!
              items.forEach { model in
                  state.categories.updateOrAppend(
                    LibraryCategoryState(
                        items: .init(uniqueElements: model.items.map { LibraryItemState(item: $0) }),
                        type: model.type
                    )
                  )
              }
              return .none
              
          case .libraryCategory(_, _):
              return .none
          }
      }
)
