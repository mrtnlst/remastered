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
                SearchListView(store: store)
                    .navigationBarTitle("Search")
                    .padding(.horizontal)
            }
            .searchable(text: viewStore.binding(\.$searchText))
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
