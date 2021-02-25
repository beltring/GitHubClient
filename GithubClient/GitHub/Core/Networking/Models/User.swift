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
}
