//
//  GalleryListView.swift
//  Remastered
//
//  Created by martin on 13.12.21.
//

import SwiftUI
import ComposableArchitecture

struct GalleryListView: View {
    let store: Store<GalleryState, GalleryAction>
    @Environment(\.isSearching) var isSearching
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView(.vertical, showsIndicators: true) {
                if isSearching {
                    librarySearchResultsList()
                } else {
                    galleryView()
                }
            }
            .padding(.horizontal)
        }
    }
}

extension GalleryListView {
    @ViewBuilder func librarySearchResultsList() -> some View {
        LazyVStack {
            ForEachStore(store.scope(
                state: \.searchResults,
                action: GalleryAction.libraryItem(id:action:))
            ) { libraryStore in
                NavigationLink(isActive: ViewStore(libraryStore).binding(\.$isActive)) {
                    LibraryItemView(store: libraryStore)
                } label: {
                    LibraryCategoryItemRow(store: libraryStore)
                }
            }
        }
    }
    
    @ViewBuilder func galleryView() -> some View {
        ForEachStore(store.scope(
            state: \.categories,
            action: GalleryAction.libraryCategory(id:action:))
        ) { store in
            galleryRow(with: store)
        }
    }
    
    @ViewBuilder func galleryRow(with store: Store<LibraryCategoryState, LibraryCategoryAction>) -> some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .center) {
                HStack(alignment: .firstTextBaseline) {
                    Text(viewStore.name)
                        .font(.headline)
                    Spacer()
                    NavigationLink(isActive: viewStore.binding(\.$isActive)) {
                        LibraryCategoryView(store: store)
                    } label: {
                        HStack(spacing: 4) {
                             Text("Show all")
                                 .font(.caption)
                             Image(systemName: "chevron.right")
                                 .font(.caption)
                         }
                         .foregroundColor(.primary)
                    }
                }
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: [GridItem(.adaptive(minimum: 50))], alignment: .center, spacing: 16) {
                        ForEachStore(store.scope(
                            state: \.items,
                            action: LibraryCategoryAction.libraryItem(id:action:))
                        ) { libraryStore in
                            NavigationLink(isActive: ViewStore(libraryStore).binding(\.$isActive)) {
                                LibraryItemView(store: libraryStore)
                            } label: {
                                ArtworkView(
                                    collection: ViewStore(libraryStore).item,
                                    cornerRadius: 8
                                )
                                    .frame(maxHeight: 80)
                                    .reflection(offsetY: 5)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
    }
}

struct GalleryListView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryListView(
            store: Store(
                initialState: GalleryState(categories: LibraryCategoryState.exampleGalleryCategories),
                reducer: galleryReducer,
                environment: GalleryEnvironment(
                    mainQueue: .main,
                    fetch: { return .none },
                    uuid: { UUID.init() }
                )
            )
        )
    }
}
