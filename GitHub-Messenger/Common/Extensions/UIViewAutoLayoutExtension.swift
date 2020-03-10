//
//  UIViewAutoLayoutExtension.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 3/3/2020.
//

import UIKit

public extension UIView {

    /// View's helper to layout the view into center of the target view
    /// - Parameter targetView: superview
    /// - Parameter size: view's size
    func layoutToCenter(of targetView: UIView, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if size != .zero {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        centerXAnchor.constraint(equalTo: targetView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: targetView.centerYAnchor).isActive = true
    }

    /// View's helper to layout the view into edges of superview
    func layoutToEdges() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        safeAreaLayoutGuide.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor).isActive = true
        safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
