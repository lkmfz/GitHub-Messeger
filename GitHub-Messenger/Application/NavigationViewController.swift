//
//  NavigationViewController.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 3/3/2020.
//

import UIKit

public class NavigationViewController: UINavigationController {

    public init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }

    override private init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
