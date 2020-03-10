//
//  ThemeInitializer.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 3/3/2020.
//

import UIKit

public class ThemeInitilializer: Initializable {

    /// App-level UI initiizer
    public func performInitilizier() {
        UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationViewController.self]).prefersLargeTitles = true
        UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationViewController.self]).tintColor = .systemBlue
        UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationViewController.self]).barTintColor = .white
        UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationViewController.self]).titleTextAttributes = [
            .foregroundColor: UIColor.darkText,
            .font: UIFont.systemFont(ofSize: 21, weight: .semibold)
        ]
    }
}
