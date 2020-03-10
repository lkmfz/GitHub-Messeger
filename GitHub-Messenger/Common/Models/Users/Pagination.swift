//
//  Pagination.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import Foundation

/// User's pagination class
public struct Pagination {
    let page: Int
    let totalCount: Int
    let nextPageURL: String
}

/// Helpers
extension Pagination {

    ///  To get the next page given current page's properties
    /// - Parameter current: current page
    /// - Parameter addedCount: additional items count
    /// - Parameter url: next page's URL
    public static func next(of current: Self, addedCount: Int = 0, url: String = "") -> Self {
        return Pagination(
            page: current.page + 1,
            totalCount: current.totalCount + addedCount,
            nextPageURL: url.isEmpty ? current.nextPageURL : url
        )
    }

    /// To get the initial pagination
    public static var first: Self {
        return Pagination(page: 1, totalCount: 0, nextPageURL: "")
    }
}
