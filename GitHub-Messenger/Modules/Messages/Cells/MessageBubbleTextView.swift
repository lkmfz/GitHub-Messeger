//
//  MessageBubbleTextView.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import UIKit

/// Bubble view's wrapper
public class MessageBubbleTextView: UITextView {

    lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()

    public init() {
        super.init(frame: .zero, textContainer: nil)
        setupViews()
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = bounds
    }

    override public var canBecomeFirstResponder: Bool {
        return false
    }

    private func setupViews() {
        isEditable = false
        isSelectable = true
        isUserInteractionEnabled = true
        delaysContentTouches = true
        isScrollEnabled = false
        alwaysBounceVertical = false
        showsVerticalScrollIndicator = false
        textContainer.lineFragmentPadding = 0
        backgroundColor = .clear
        textColor = .white
        font = UIFont.preferredFont(forTextStyle: .title3)
        dataDetectorTypes = [.flightNumber, .calendarEvent, .address, .phoneNumber, .link, .lookupSuggestion]
        linkTextAttributes = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.white
        ]

        insertSubview(backgroundImageView, at: 0)
        backgroundImageView.frame = bounds
    }

    func calculatedSize(in size: CGSize) -> CGSize {
        return sizeThatFits(CGSize(width: size.width * 0.8, height: .infinity))
    }
}
