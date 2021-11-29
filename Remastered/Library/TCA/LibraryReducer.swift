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
                  .catchToEffect(LibraryAction.receiveCategoryModels)
              
          case let .receiveCategoryModels(.success(models)):
              models.forEach { model in
                  let items = IdentifiedArrayOf<LibraryItemState>(
                    uniqueElements: model.items.map {
                        LibraryItemState(
                            item: $0,
                            id: environment.uuid()
                        )
                    }
                  )
                  let category = LibraryCategoryState(
                    items: items,
                    type: model.type,
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
