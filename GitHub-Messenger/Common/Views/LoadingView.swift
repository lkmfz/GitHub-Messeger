//
//  LoadingView.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 3/3/2020.
//

import UIKit

/// Base Loading Indicator View class
public final class LoadingView: UIView {

    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.startAnimating()
        return view
    }()

    public init() {
        super.init(frame: .zero)
        alpha = 0.5
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = .darkGray
        addSubview(indicator)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        indicator.layoutToCenter(of: self)
    }

    public func stop() {
        isHidden = true
    }

    public func start() {
        isHidden = false
    }
}
