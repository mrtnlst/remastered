//
//  LibraryView.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import SwiftUI
import CombineSchedulers
import ComposableArchitecture

struct LibraryView: View {
    let store: Store<LibraryState, LibraryAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    ForEachStore(store.scope(
                        state: \.categories,
                        action: LibraryAction.libraryCategory(id:action:))
                    ) { store in
                        NavigationLink {
                            LibraryCategoryView(store: store)
                        } label: {
                            HStack {
                                Image(systemName: ViewStore(store).type.icon)
                                Text(ViewStore(store).type.rawValue)
                            }
                        }
                    }
                }
                .navigationBarTitle("Library")
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(
            store: Store(
                initialState: LibraryState(
                    categories: LibraryCategoryState.exampleCategories
                ),
                reducer: libraryReducer,
                environment: LibraryEnvironment(
                    mainQueue: .main,
                    fetch: { return .none },
                    uuid: { UUID.init() }
                )
            )
        )
    }
}
