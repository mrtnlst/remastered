//
//  SearchListView.swift
//  Remastered
//
//  Created by martin on 18.12.21.
//

import SwiftUI
import ComposableArchitecture

struct SearchListView: View {
    let store: Store<SearchState, SearchAction>
    @Environment(\.isSearching) var isSearching
    
    var body: some View {
        if isSearching {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack {
                    searchListView()
                }
            }
        } else {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                Text("Search your library")
                    .foregroundColor(.secondary)
            }
        }
    }
}

extension SearchListView {
    @ViewBuilder func searchListView() -> some View {
        WithViewStore(store) { viewStore in
            ForEach(viewStore.searchResults) { searchResult in
                NavigationLink(
                    destination: IfLetStore(
                        store.scope(
                            state: { $0.selectedItem?.value },
                            action: SearchAction.libraryItem
                        ),
                        then: LibraryItemView.init(store:)
                    ),
                    tag: searchResult.id,
                    selection: viewStore.binding(
                        get: { $0.selectedItem?.id },
                        send: SearchAction.setItemNavigation(selection:)
                    )
                ) {
                    LibraryCategoryItemRow(collection: searchResult.collection)
                }
            }
        }
    }
}


struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListView(
            store: Store(
                initialState: SearchState(
                    searchResults: LibraryCategoryState.exampleLibraryAlbums
                ),
                reducer: searchReducer,
                environment: SearchEnvironment(
                    mainQueue: .main,
                    fetch: { return .none },
                    uuid: { UUID.init() }
                )
            )
        )
    }
}
