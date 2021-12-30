//
//  LibraryCategoryView.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import SwiftUI
import ComposableArchitecture

struct LibraryCategoryView: View {
    let store: Store<LibraryCategoryState, LibraryCategoryAction>
    @AppStorage("category-display-style") var displayStyle: CategoryDisplayStyle = .list
    
    init(store: Store<LibraryCategoryState, LibraryCategoryAction>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView(.vertical, showsIndicators: true) {
                switch displayStyle {
                case .list:
                    listView()
                case .grid:
                    gridView()
                }
            }
            .navigationBarTitle(viewStore.name)
            .toolbar { CategoryToolbar(displayStyle: $displayStyle) }
        }
    }
}

extension LibraryCategoryView {
    @ViewBuilder func gridView() -> some View {
        LazyVGrid(columns: [GridItem(spacing: 16), GridItem(spacing: 16)], spacing: 16) {
            ForEachStore(store.scope(
                state: \.items,
                action: LibraryCategoryAction.libraryItem(id:action:))
            ) { libraryStore in
                NavigationLink {
                    LibraryItemView(store: libraryStore)
                } label: {
                    ArtworkView(
                        with: .collection(ViewStore(libraryStore).collection),
                        cornerRadius: 8,
                        shadowRadius: 3
                    )
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder func listView() -> some View {
        LazyVStack {
            ForEachStore(store.scope(
                state: \.items,
                action: LibraryCategoryAction.libraryItem(id:action:))
            ) { store in
                NavigationLink {
                    LibraryItemView(store: store)
                } label: {
                    WithViewStore(store) { viewStore in
                        LibraryCategoryItemRow(collection: viewStore.collection)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct LibraryCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LibraryCategoryView(
                store: Store(
                    initialState: LibraryCategoryState.exampleLibraryCategories.first!,
                    reducer: libraryCategoryReducer,
                    environment: LibraryCategoryEnvironment()
                )
            )
        }
    }
}
