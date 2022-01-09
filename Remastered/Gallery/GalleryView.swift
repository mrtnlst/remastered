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
                ZStack {
                    emptyNavigationLink()
                    ScrollView(.vertical, showsIndicators: true) {
                        ForEachStore(
                            store.scope(
                                state: \.rows,
                                action: GalleryAction.galleryRowAction(id:action:)
                            )
                        ) { rowStore in
                            GalleryRowView(store: rowStore)
                        }
                    }
                    .padding(.horizontal)
                    .navigationBarTitle("Gallery")
                }
                .onAppear { viewStore.send(.onAppear) }
            }
        }
    }
}

extension GalleryView {
    @ViewBuilder func emptyNavigationLink() -> some View {
        WithViewStore(store) { viewStore in
            NavigationLink(
                destination: IfLetStore(
                    store.scope(
                        state: { $0.selectedItem?.value },
                        action: GalleryAction.libraryItem
                    ),
                    then: LibraryItemView.init(store:)
                ),
                tag: viewStore.emptyNavigationLinkId,
                selection: viewStore.binding(
                    get: { $0.selectedItem?.id },
                    send: GalleryAction.setItemNavigation(selection:)
                )
            ) {
                EmptyView()
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(
            store: Store(
                initialState: GalleryState(rows: LibraryCategoryState.exampleGalleryRows),
                reducer: galleryReducer,
                environment: GalleryEnvironment(
                    mainQueue: .main,
                    uuid: { UUID.init() },
                    fetch: { _ in return .none }
                )
            )
        )
    }
}
