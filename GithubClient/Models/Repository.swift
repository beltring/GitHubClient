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
    let owner: Owner?
    let url: String
    let pullUrl: String?
    let branchesUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, language, owner
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case defaultBranch = "default_branch"
        case commitsUrl = "commits_url"
        case url = "html_url"
        case pullUrl = "pulls_url"
        case branchesUrl = "branches_url"
    }
}
