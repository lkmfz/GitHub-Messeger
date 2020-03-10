//
//  PlaceholderEmptyView.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 3/3/2020.
//

import UIKit

/// Base Placeholder View class for empty data state
final class PlaceholderEmptyView: UIView {

    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    public var tapActionHandler: (() -> Void)?

    public init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true

        addSubview(messageLabel)
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.0).isActive = true
        messageLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 100.0).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -15.0).isActive = true
    }

    @objc private func didTapButton() {
        tapActionHandler?()
    }

    public func show(title: String, message: String, themeColor: UIColor = .red) {
        isHidden = false
        button.layer.borderColor = themeColor.cgColor
        button.setTitleColor(themeColor, for: .normal)
        button.setTitleColor(themeColor.withAlphaComponent(0.5), for: .highlighted)
        button.setTitle(title, for: .normal)
        messageLabel.text = message
        messageLabel.textColor = themeColor.withAlphaComponent(0.7)
        messageLabel.sizeToFit()
    }

    public func hide() {
        isHidden = true
    }
}
