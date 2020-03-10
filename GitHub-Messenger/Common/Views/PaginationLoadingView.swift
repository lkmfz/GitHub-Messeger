//
//  PaginationLoadingView.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 3/3/2020.
//

import UIKit

/// Base Pagination Loading View class
public final class PaginationLoadingView: UIView {

    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Try Again?", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(UIColor.red.withAlphaComponent(0.5), for: .highlighted)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(didTapRetryButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    public var tapActionHandler: (() -> Void)?

    public init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        addSubview(indicator)
        addSubview(retryButton)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        indicator.layoutToCenter(of: self)

        retryButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        retryButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        retryButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        retryButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5).isActive = true
    }

    @objc private func didTapRetryButton() {
        startAnimating()
        hideRetryButton()
        tapActionHandler?()
    }

    public func startAnimating() {
        indicator.startAnimating()
    }

    public func stopAnimating() {
        indicator.stopAnimating()
    }

    public func showRetryButton() {
        retryButton.isHidden = false
    }

    public func hideRetryButton() {
        retryButton.isHidden = true
    }
}
