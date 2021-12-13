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
    @State private var searchText = ""
    
    init(store: Store<LibraryState, LibraryAction>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                LibraryListView(store: store)
                    .listStyle(PlainListStyle())
                    .navigationBarTitle("Library")
                
            }
            .searchable(
                text: viewStore.binding(\.$searchText),
                placement: .automatic
            )
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(
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
