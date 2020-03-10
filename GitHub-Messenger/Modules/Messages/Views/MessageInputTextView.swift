//
//  MessageInputTextView.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import UIKit

/// TextView's container view
public class MessageInputTextView: UIView {
    
    struct Constants {
        static let maxHeight: CGFloat = 150.0
    }

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 20
        textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textView.textColor = UIColor.darkGray
        textView.showsVerticalScrollIndicator = false
        textView.delegate = self
        return textView
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.placeholderText
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Aa"
        return label
    }()

    /// Calculated of current textview height
    private var calculatedHeight: CGFloat {
        return textView.sizeThatFits(CGSize(width: textView.bounds.size.width, height: .infinity)).height
    }

    private var heightConstraint: NSLayoutConstraint!

    public var text: String {
        return textView.text
    }

    /// Textview's text change event callback
    public var didChangeText: ((_ text: String) -> Void)?

    public init() {
        super.init(frame: .zero)
        setupViews()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        addSubview(placeholderLabel)
        
        heightConstraint = textView.heightAnchor.constraint(equalToConstant: calculatedHeight)
        heightConstraint.isActive = true

        textView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        textView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        placeholderLabel.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 16).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -16).isActive = true
    }

    func resetTextView() {
        // Hide placeholder label and clear textfield
        placeholderLabel.isHidden = false
        textView.text = ""

        // Reset textview's height
        let expectedHeight = (calculatedHeight < Constants.maxHeight) ? calculatedHeight : Constants.maxHeight
        heightConstraint.constant = expectedHeight
    }
}

extension MessageInputTextView: UITextViewDelegate {

    public func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.isEmpty
    }

    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty

        // Update expanded textview's height
        let expectedHeight = (calculatedHeight < Constants.maxHeight) ? calculatedHeight : Constants.maxHeight
        heightConstraint.constant = expectedHeight

        didChangeText?(textView.text)
    }
}
