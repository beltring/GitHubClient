//
//  Author.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/25/21.
//

import Foundation

struct Author: Decodable {
    let name: String?
    let email: String?
    let date: String?
}
