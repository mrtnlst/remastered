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
        WithViewStore(store) { viewStore in
            ForEach(viewStore.searchResults) { item in
                NavigationLink(
                    destination: IfLetStore(
                        store.scope(
                            state: { $0.selectedSearchResult?.value },
                            action: LibraryAction.libraryItem
                        ),
                        then: LibraryItemView.init(store:)
                    ),
                    tag: item.id,
                    selection: viewStore.binding(
                        get: { $0.selectedSearchResult?.id },
                        send: LibraryAction.setSearchResultNavigation(selection:)
                    )
                ) {
                    LibraryCategoryItemRow(collection: item.item)
                }
            }
        }
    }
    
    @ViewBuilder func libraryCategoryList() -> some View {
        WithViewStore(store) { viewStore in
            ForEach(viewStore.categories) { category in
                NavigationLink(
                    destination: IfLetStore(
                        store.scope(
                            state: { $0.selectedCategory?.value },
                            action: LibraryAction.libraryCategory
                        ),
                        then: LibraryCategoryView.init(store:)
                    ),
                    tag: category.id,
                    selection: viewStore.binding(
                        get: { $0.selectedCategory?.id },
                        send: LibraryAction.setCategoryNavigation(selection:)
                    )
                ) {
                    VStack {
                        HStack {
                            Image(systemName: category.icon ?? "questionmark")
                                .frame(width: 32)
                                .font(.title3)
                            Text(category.name)
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
