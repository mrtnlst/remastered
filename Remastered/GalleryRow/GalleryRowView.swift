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
            VStack(alignment: .center) {
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
                    LazyHGrid(rows: [GridItem(.adaptive(minimum: 50))], alignment: .center, spacing: 16) {
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
                                    collection: item.item,
                                    cornerRadius: 8
                                )
                                    .frame(minHeight: 80, maxHeight: 80)
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


struct GalleryRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.vertical, showsIndicators: true) {
            GalleryRowView(
                store: Store(
                    initialState: LibraryCategoryState.exampleGalleryRows[1],
                    reducer: galleryRowReducer,
                    environment: GalleryRowEnvironment())
            )
        }
        .padding(.horizontal)
    }
}
