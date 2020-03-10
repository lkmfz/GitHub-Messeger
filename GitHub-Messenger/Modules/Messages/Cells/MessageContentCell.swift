//
//  MessageContentCell.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import UIKit

/// Base messaging item cell's class
public class MessageContentCell: UICollectionViewCell {

    public struct NibName {
        static let outgoing = "MessageOutgoingContentCell"
        static let incoming = "MessageIncomingContentCell"
    }

    @IBOutlet private weak var bubble: MessageBubbleTextView!
    @IBOutlet private weak var bubbleWidth: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        let bubbleSize = bubble.calculatedSize(in: bounds.size)
        bubbleWidth.constant = bubbleSize.width
    }

    func configure(_ message: MessageContentItemInterface) {
        guard case .text(let textMessage) = message.messageContent else {
            return
        }
        bubble.text = textMessage
        bubble.backgroundImageView.image = UIImage(named: message.direction.assetName)?.resizableImage(
            withCapInsets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20),
            resizingMode: .stretch
        )

        switch message.direction {
        case .outgoing:
            bubble.textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 20)
        case .incoming:
            bubble.textContainerInset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 15)
        }
    }
}
