//
//  TabBarProxy.swift
//  Remastered
//
//  Created by martin on 19.12.21.
//

import SwiftUI

protocol TabBarProxyDelegate: AnyObject {
    func didUpdate(height: CGFloat, offset: CGFloat)
}

class TabBarProxyController: UIViewController {
    weak var delegate: TabBarProxyDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBar = tabBarController?.tabBar {
            delegate?.didUpdate(
                height: tabBar.bounds.height - tabBar.safeAreaInsets.bottom,
                offset: tabBar.safeAreaInsets.bottom
            )
        }
    }
}

/// This proxy is used to gather the tab bar height and offset.
struct TabBarProxy: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    let height: Binding<CGFloat>
    let offset: Binding<CGFloat>
    private let proxyController = TabBarProxyController()

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<TabBarProxy>
    ) -> UIViewController {
        proxyController.delegate = context.coordinator
        return proxyController
    }

    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: UIViewControllerRepresentableContext<TabBarProxy>
    ) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(height: height, offset: offset)
    }

    class Coordinator: TabBarProxyDelegate {
        let height: Binding<CGFloat>
        let offset: Binding<CGFloat>
        
        init(height: Binding<CGFloat>, offset: Binding<CGFloat>) {
            self.height = height
            self.offset = offset
        }
        
        func didUpdate(height: CGFloat, offset: CGFloat) {
            self.height.wrappedValue = height
            self.offset.wrappedValue = offset
        }
    }
}
