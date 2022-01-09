//
//  AirPlayButton.swift
//  Remastered
//
//  Created by martin on 09.01.22.
//

import SwiftUI
import AVKit

struct AirPlayButton: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        return AVRoutePickerView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
