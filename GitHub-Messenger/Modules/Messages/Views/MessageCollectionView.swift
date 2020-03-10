//
//  MessageCollectionView.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import UIKit

/// Base collection view class for Messaging view
public final class MessageCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        alwaysBounceVertical = true
        backgroundColor = .white
        keyboardDismissMode = .onDrag
        contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 5, right: 0)
        contentInsetAdjustmentBehavior = .always
        register(nibName: MessageContentCell.NibName.outgoing)
        register(nibName: MessageContentCell.NibName.incoming)
    }

    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    convenience init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    @discardableResult func calculatedCellSize(message: MessageContentItemInterface, indexPath: IndexPath) -> CGSize {
        guard case .text(let textMessage) = message.messageContent else {
            return CGSize(width: bounds.width, height: 0)
        }
        let bubbleView = MessageBubbleTextView()
        bubbleView.text = textMessage
        let bubbleSize = bubbleView.calculatedSize(in: CGSize(width: bounds.width, height: .infinity))
        return CGSize(width: bounds.width, height: bubbleSize.height)
    }
}
