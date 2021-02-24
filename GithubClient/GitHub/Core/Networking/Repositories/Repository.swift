//
//  Repository.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/24/21.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let name: String
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int?
    let language: String?
    let defaultBranch: String?
    let commitsUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case defaultBranch = "default_branch"
        case commitsUrl = "commits_url"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(stargazersCount, forKey: .stargazersCount)
        try container.encode(forksCount, forKey: .forksCount)
        try container.encode(watchersCount, forKey: .watchersCount)
        try container.encode(language, forKey: .language)
        try container.encode(defaultBranch, forKey: .defaultBranch)
        try container.encode(commitsUrl, forKey: .commitsUrl)
      }
}

