//
//  TableView.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 3/3/2020.
//

import UIKit

/// Base UITableView class
public class TableView: UITableView {

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupViews()
    }

    public init() {
        super.init(frame: .zero, style: .plain)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        rowHeight = UITableView.automaticDimension
    }

    public func show() {
        isHidden = false
    }

    public func hide() {
        isHidden = true
    }
}
