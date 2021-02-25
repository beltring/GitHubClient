//
//  Commit.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/25/21.
//

import Foundation

struct CommitData: Decodable {
    let commit: Commit?
    let commiter: Owner?
}

struct Commit: Decodable {
    let message: String?
    let url: String?
    let author: Author?
}
