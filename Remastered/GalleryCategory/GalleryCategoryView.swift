//
//  GalleryCategoryView.swift
//  Remastered
//
//  Created by martin on 05.12.21.
//

import SwiftUI
import ComposableArchitecture

struct GalleryCategoryView: View {
    let store: Store<GalleryCategoryState, GalleryCategoryAction>
    
    var body: some View {
        Text("This becomes the 'Show All' view")
    }
}

struct GalleryCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryCategoryView(
            store: Store(
                initialState: GalleryCategoryState.exampleCategories.first!,
                reducer: galleryCategoryReducer,
                environment: GalleryCategoryEnvironment()
            )
                                
        )
    }
}
