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
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack {
                    if isSearching {
                        librarySearchResultsList()
                    } else {
                        libraryCategoryList()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

extension LibraryListView {
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
    
    @ViewBuilder func libraryCategoryList() -> some View {
        ForEachStore(store.scope(
            state: \.categories,
            action: LibraryAction.libraryCategory(id:action:))
        ) { store in
            NavigationLink {
                LibraryCategoryView(store: store)
            } label: {
                VStack {
                    HStack {
                        Image(systemName: ViewStore(store).icon ?? "questionmark")
                            .frame(width: 32)
                            .font(.title3)
                        Text(ViewStore(store).name)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                    Divider()
                }
            }
        }
    }
}

struct LibraryListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
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
                .navigationBarTitle("Library")
        }
    }
}
