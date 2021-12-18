//
//  GalleryView.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import SwiftUI
import CombineSchedulers
import ComposableArchitecture

struct GalleryView: View {
    let store: Store<GalleryState, GalleryAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(viewStore.categories) { category in
                        VStack(alignment: .center) {
                            galleryRowHeader(for: category)
                            galleryRowBody(for: category)
                        }
                    }
                }
                .padding(.horizontal)
                .navigationBarTitle("Gallery")
            }
        }
    }
}

extension GalleryView {
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
                            action: GalleryAction.libraryCategory
                        ),
                        then: LibraryCategoryView.init(store:)
                    ),
                    tag: category.id,
                    selection: viewStore.binding(
                        get: { $0.selectedCategory?.id },
                        send: GalleryAction.setCategoryNavigation(selection:)
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
                                        action: GalleryAction.libraryItem
                                    ),
                                    then: LibraryItemView.init(store:)
                                ),
                                tag: item.id,
                                selection: viewStore.binding(
                                    get: { $0.selectedItem?.id },
                                    send: GalleryAction.setItemNavigation(selection:)
                                )
                            ) {
                                ArtworkView(
                                    collection: item.item,
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


struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(
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
