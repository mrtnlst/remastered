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
                List {
                    ForEach(viewStore.libraryRowModels) { model in
                        NavigationLink {
                            listView(with: viewStore, model: model)
                        } label: {
                            HStack {
                                Image(systemName: model.type.icon)
                                Text(model.type.rawValue)
                            }
                        }
                    }
                }
                .navigationBarTitle("Library")
            }
        }
    }
}

extension LibraryView {
    @ViewBuilder func listView(with viewStore: ViewStore<LibraryState, LibraryAction>, model: LibraryRowModel) -> some View {
        List {
            ForEach(model.items) { item in
                Button {
                    viewStore.send(LibraryAction.didSelectItem(id: item.id))
                } label: {
                    HStack {
                        if let image = item.artwork {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 50)
                                .cornerRadius(4)
                        } else {
                            Image(systemName: "rectangle.stack.fill")
                        }
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .foregroundColor(.primary)
                            Text(item.artist)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.init(arrayLiteral: .bottom, .top), 5)
                }
            }
        }
        .navigationBarTitle(model.type.rawValue)
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(
            store:
                Store(
                    initialState: LibraryState(libraryRowModels: LibraryRowModel.exampleRowModels),
                    reducer: libraryReducer,
                    environment: LibraryEnvironment(mainQueue: .main, fetch: { return .none })
                )
        )
    }
}
