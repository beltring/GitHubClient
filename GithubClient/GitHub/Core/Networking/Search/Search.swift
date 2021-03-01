//
//  Search.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/1/21.
//

import Foundation

struct RepositoriesData: Decodable {
    let count: Int?
    let repositories: [Repository]?
    
    private enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case repositories = "items"
    }
}
