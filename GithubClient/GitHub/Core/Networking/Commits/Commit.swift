//
//  Commit.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/25/21.
//

import Foundation

struct CommitData: Decodable {
    let commit: Commit?
    let committer: Owner?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case commit, committer
        case url = "html_url"
    }
}

struct Commit: Decodable {
    let message: String?
    let author: Author?
}
