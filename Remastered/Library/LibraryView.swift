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
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ZStack {
                    emptyNavigationLink()
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack {
                            ForEach(viewStore.categories) { category in
                                categoryRow(for: category)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .navigationBarTitle("Library")
                }
            }
        }
    }
}

extension LibraryView {
    @ViewBuilder func categoryRow(for category: LibraryCategoryState) -> some View {
        NavigationLink(
            destination: IfLetStore(
                store.scope(
                    state: { $0.selectedCategory?.value },
                    action: LibraryAction.libraryCategory
                ),
                then: LibraryCategoryView.init(store:)
            ),
            tag: category.id,
            selection: ViewStore(store).binding(
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
    
    @ViewBuilder func emptyNavigationLink() -> some View {
        WithViewStore(store) { viewStore in
            NavigationLink(
                destination: IfLetStore(
                    store.scope(
                        state: { $0.selectedItem?.value },
                        action: LibraryAction.libraryItem
                    ),
                    then: LibraryItemView.init(store:)
                ),
                tag: viewStore.emptyNavigationLinkId,
                selection: viewStore.binding(
                    get: { $0.selectedItem?.id },
                    send: LibraryAction.setItemNavigation(selection:)
                )
            ) {
                EmptyView()
            }
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
                    fetch: { _ in return .none },
                    mainQueue: .main,
                    uuid: { UUID.init() }
                )
            )
        )
    }
}
