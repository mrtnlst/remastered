//
//  LibraryCategoryItemRow.swift
//  Remastered
//
//  Created by martin on 13.12.21.
//

import SwiftUI

struct LibraryCategoryItemRow: View {
    let collection: LibraryCollection
    
    var body: some View {
        HStack {
            ArtworkView(with: .collection(collection), cornerRadius: 4, shadowRadius: 2)
                .frame(maxHeight: 50)
            VStack(alignment: .leading) {
                Text(collection.title)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(collection.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                if collection.isCloudItem {
                    Image(systemName: "cloud")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
            }
            Spacer(minLength: 10)
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}

struct LibraryCategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LibraryCategoryItemRow(
                collection: LibraryCollection.examplePlaylists[0]
            )
            LibraryCategoryItemRow(
                collection: LibraryCollection.exampleGenres[0]
            )
        }
        .padding(.horizontal)
    }
}
