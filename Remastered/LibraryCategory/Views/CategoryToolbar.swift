//
//  CategoryToolbar.swift
//  Remastered
//
//  Created by martin on 12.12.21.
//

import SwiftUI

struct CategoryToolbar: ToolbarContent {
    @Binding var displayStyle: CategoryDisplayStyle
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Button {
                    displayStyle = .grid
                } label: {
                    Label(CategoryDisplayStyle.grid.text, systemImage: CategoryDisplayStyle.grid.icon)
                        .autocapitalization(.words)
                }
                Button {
                    displayStyle = .list
                } label: {
                    Label(CategoryDisplayStyle.list.text, systemImage: CategoryDisplayStyle.list.icon)
                }
            } label: {
                ZStack {
                    Image(systemName: "circle.fill")
                        .font(Font.title2)
                    Image(systemName: displayStyle.icon)
                        .font(.caption.weight(displayStyle == .list ? .bold : .thin))
                        .foregroundColor(.primary)
                        .colorInvert()
                }
            }
        }
     }
}

struct CategoryToolbar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("Menu")
                .navigationTitle("Text")
                .toolbar {
                    CategoryToolbar(displayStyle: .constant(.list))
                }
        }
    }
}
