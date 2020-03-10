//
//  MessageInputView.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import UIKit

/// Top text input view
public class MessageInputView: UIView {

    private struct Constants {
        static let height: CGFloat = 60.0
    }

    private lazy var textInputView: MessageInputTextView = {
        let view = MessageInputTextView()
        view.didChangeText = handleTextChange
        return view
    }()

    var didSendMessage: ((_ input: String) -> Void)?

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitleColor(UIColor.systemGray4, for: .disabled)
        button.isEnabled = false
        button.sizeToFit()
        return button
    }()

    public init() {
        super.init(frame: .zero)
        setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        addSubview(sendButton)
        addSubview(textInputView)

        sendButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: sendButton.bounds.width).isActive = true

        textInputView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textInputView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textInputView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        textInputView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8).isActive = true
    }

    @objc private func didTapSendButton(_ sender: UIButton) {
        didSendMessage?(textInputView.text)
        sendButton.isEnabled = false
        textInputView.resetTextView()
    }

    private func handleTextChange(_ text: String) {
        sendButton.isEnabled = !text.isEmpty
    }
}
