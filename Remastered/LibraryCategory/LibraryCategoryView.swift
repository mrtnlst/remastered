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
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEachStore(store.scope(
                    state: \.items,
                    action: LibraryCategoryAction.libraryItem(id:action:))
                ) { store in
                    NavigationLink {
                        LibraryItemView(store: store)
                    } label: {
                        HStack {
                            if let image = ViewStore(store).item.artwork {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 50)
                                    .cornerRadius(4)
                            } else {
                                Image(systemName: "rectangle.stack.fill")
                            }
                            VStack(alignment: .leading) {
                                Text(ViewStore(store).item.title)
                                    .foregroundColor(.primary)
                                Text(ViewStore(store).item.artist)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.init(arrayLiteral: .bottom, .top), 5)
                    }
                }
            }
            .navigationBarTitle(viewStore.type.rawValue)
        }
    }
}

struct LibraryCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LibraryCategoryView(
                store: Store(
                    initialState: LibraryRowModel.exampleCategories.first!,
                    reducer: libraryCategoryReducer,
                    environment: LibraryCategoryEnvironment()
                )
            )
        }
    }
}
