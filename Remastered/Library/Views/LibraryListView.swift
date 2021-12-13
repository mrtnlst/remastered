//
//  LibraryListView.swift
//  Remastered
//
//  Created by martin on 13.12.21.
//

import SwiftUI
import ComposableArchitecture

struct LibraryListView: View {
    let store: Store<LibraryState, LibraryAction>
    @Environment(\.isSearching) var isSearching
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                if isSearching {
                    librarySearchResultsList()
                } else {
                    libraryCategoryList()
                }
            }
        }
    }
}

extension LibraryListView {
    @ViewBuilder func libraryCategoryList() -> some View {
        ForEachStore(store.scope(
            state: \.categories,
            action: LibraryAction.libraryCategory(id:action:))
        ) { store in
            NavigationLink {
                LibraryCategoryView(store: store)
            } label: {
                if let icon = ViewStore(store).icon {
                    HStack {
                        Image(systemName: icon)
                        Text(ViewStore(store).name)
                    }
                }
            }
        }
    }
    
    @ViewBuilder func librarySearchResultsList() -> some View {
        ForEachStore(store.scope(
            state: \.searchResults,
            action: LibraryAction.libraryItem(id:action:))
        ) { libraryStore in
            NavigationLink {
                LibraryItemView(store: libraryStore)
            } label: {
                LibraryCategoryItemRow(store: libraryStore)
            }
        }
    }
}

struct LibraryListView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryListView(
            store: Store(
                initialState: LibraryState(
                    categories: LibraryCategoryState.exampleLibraryCategories
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
