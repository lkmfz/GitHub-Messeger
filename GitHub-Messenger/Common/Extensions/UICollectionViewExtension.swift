//
//  UICollectionViewExtension.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import UIKit

public extension UICollectionView {

    /// Scrolls the collection view to the very bottom.
    ///
    /// - Parameter animated: Whether the scrolling should be animated or not
    func scrollToBottom(animated: Bool) {
        guard contentSize.height > bounds.size.height else { return }
        setContentOffset(CGPoint(x: 0, y: (contentSize.height - bounds.size.height) + (contentInset.bottom)), animated: animated)
    }

    /// Register UICollectionViewCell with .xib file using only its corresponding class.
    ///
    /// - Parameters:
    ///   - name: UINib name.
    func register(nibName name: String) {
        register(UINib(nibName: name, bundle: Bundle.main), forCellWithReuseIdentifier: name)
    }

    /// Dequeue reusable UICollectionViewCell using class name.
    ///
    /// - Parameters:
    ///   - name: UICollectionViewCell type.
    ///   - Parameter identifier: cell identifier
    ///   - indexPath: location of cell in collectionView.
    /// - Returns: UICollectionViewCell object with associated class name.
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(identifier)")
        }
        return cell
    }

    /// Index of last section in collectionView.
    var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
}
