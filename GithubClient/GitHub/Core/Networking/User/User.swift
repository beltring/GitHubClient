//
//  User.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/26/21.
//

import Foundation

struct User: Decodable {
    let login: String?
    let name: String?
    let location: String?
    let email: String?
    let followers: Int?
    let following: Int?
    let avatarUrl: String?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case login
        case name
        case location
        case email
        case followers
        case following
        case avatarUrl = "avatar_url"
        case url = "html_url"
    }
}
