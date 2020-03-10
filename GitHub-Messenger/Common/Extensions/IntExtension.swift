//
//  IntExtension.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import Foundation

public extension Int {
    /// To check whether a number is odd or even
    func isOddNumber() -> Bool {
        return (self % 2 == 0)
    }
}
