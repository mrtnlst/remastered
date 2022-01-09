//
//  GalleryRowView.swift
//  Remastered
//
//  Created by martin on 25.12.21.
//

import SwiftUI
import ComposableArchitecture

struct GalleryRowView: View {
    let store: Store<GalleryRowState, GalleryRowAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .center, spacing: 0) {
                galleryRowHeader(for: viewStore.category)
                galleryRowBody(for: viewStore.category)
            }
        }
    }
}

extension GalleryRowView {
    @ViewBuilder func galleryRowHeader(for category: LibraryCategoryState) -> some View {
        WithViewStore(store) { viewStore in
            HStack(alignment: .firstTextBaseline) {
                Text(category.name)
                    .font(.headline)
                Spacer()
                NavigationLink(
                    destination: IfLetStore(
                        store.scope(
                            state: { $0.selectedCategory?.value },
                            action: GalleryRowAction.libraryCategory
                        ),
                        then: LibraryCategoryView.init(store:)
                    ),
                    tag: category.id,
                    selection: viewStore.binding(
                        get: { $0.selectedCategory?.id },
                        send: GalleryRowAction.setCategoryNavigation(selection:)
                    )
                ) {
                    HStack(spacing: 4) {
                        Text("Show all")
                            .font(.caption)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
    
    @ViewBuilder func galleryRowBody(for category: LibraryCategoryState) -> some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .center) {
                ScrollView(.horizontal, showsIndicators: true) {
                    ScrollViewReader { reader in
                        LazyHGrid(rows: [GridItem(.adaptive(minimum: 50))], alignment: .center, spacing: 0) {
                            ForEach(category.items) { item in
                                NavigationLink(
                                    destination: IfLetStore(
                                        store.scope(
                                            state: { $0.selectedItem?.value },
                                            action: GalleryRowAction.libraryItem
                                        ),
                                        then: LibraryItemView.init(store:)
                                    ),
                                    tag: item.id,
                                    selection: viewStore.binding(
                                        get: { $0.selectedItem?.id },
                                        send: GalleryRowAction.setItemNavigation(selection:)
                                    )
                                ) {
                                    ArtworkView(
                                        with: .collection(item.collection),
                                        cornerRadius: 8,
                                        shadowRadius: 2
                                    )
                                        .frame(minHeight: 80, maxHeight: 80)
                                        .reflection(offsetY: 5)
                                        .padding(8)
                                }
                            }
                        }
                        .onChange(of: viewStore.category) { _ in
                            // Scrolls the discover row to the beginning, otherwise the selected
                            // item view might get dismissed while the app enters the foregound.
                            guard GalleryCategoryType(from: viewStore.id) == .discover,
                                  let itemId = viewStore.selectedItem?.id
                            else { return }
                            reader.scrollTo(itemId)
                        }
                        .padding(.bottom, 16)
                    }
                }
            }
        }
    }
}


struct GalleryRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.vertical, showsIndicators: true) {
            GalleryRowView(
                store: Store(
                    initialState: LibraryCategoryState.exampleGalleryRows[0],
                    reducer: galleryRowReducer,
                    environment: GalleryRowEnvironment())
            )
        }
        .padding(.horizontal)
    }
}
