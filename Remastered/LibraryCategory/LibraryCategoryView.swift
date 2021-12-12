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
            .padding(.horizontal, 16)
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
                        collection: ViewStore(libraryStore).item,
                        cornerRadius: 8
                    )
                }
            }
        }
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
                    HStack {
                        ArtworkView(collection: ViewStore(store).item, cornerRadius: 4)
                            .frame(maxHeight: 50)
                        VStack(alignment: .leading) {
                            Text(ViewStore(store).item.title)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            Text(ViewStore(store).item.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                            if ViewStore(store).item.isCloudItem {
                                Image(systemName: "cloud")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }
                        Spacer(minLength: 8)
                    }
                    .padding(.init(arrayLiteral: .bottom, .top), 5)
                }
            }
        }
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
