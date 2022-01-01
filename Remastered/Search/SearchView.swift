//
//  SearchView.swift
//  Remastered
//
//  Created by martin on 18.12.21.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ZStack {
                    emptyNavigationLink()
                    SearchListView(store: store)
                        .navigationBarTitle("Search")
                        .padding(.horizontal)
                }
            }
            .searchable(text: viewStore.binding(\.$searchText))
            .disableAutocorrection(true)
        }
    }
}

extension SearchView {
    @ViewBuilder func emptyNavigationLink() -> some View {
        WithViewStore(store) { viewStore in
            NavigationLink(
                destination: IfLetStore(
                    store.scope(
                        state: { $0.selectedItem?.value },
                        action: SearchAction.libraryItem
                    ),
                    then: LibraryItemView.init(store:)
                ),
                tag: viewStore.emptyNavigationLinkId,
                selection: viewStore.binding(
                    get: { $0.selectedItem?.id },
                    send: SearchAction.setItemNavigation(selection:)
                )
            ) {
                EmptyView()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(
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
