//
//  User.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 3/3/2020.
//

import Foundation

/// User model class
public struct User: Decodable {
    let id: Int
    let username: String
    let avatarURL: String

    private enum CodingKeys : String, CodingKey {
         case id, username = "login", avatarURL = "avatar_url"
     }
}

/// VIPER's model interface
extension User: UserContentItemInterface {

    var title: String? {
        return "@" + username
    }

    var imageURL: String? {
        return avatarURL
    }
}

/// Helpers
extension User {

    public typealias GitHubSuccessResponse = (users: [User], nextURL: String)

    static func mock(count: Int) -> [User] {
        var list: [User] = []
        var i = 1
        while i <= count {
            list.append(User(id: i, username: "user.\(i)", avatarURL: "https://avatars2.githubusercontent.com/u/14\(i)?v=4"))
            i += 1
        }
        return list
    }
}
