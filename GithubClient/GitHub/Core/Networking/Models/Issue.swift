//
//  Issue.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/26/21.
//

import Foundation

struct Issue: Decodable {
    let title: String?
    let number: Int?
    let createdDate: String?
    let url: String?
    let repositoryUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, number
        case createdDate = "created_at"
        case url = "html_url"
        case repositoryUrl = "repository_url"
    }
}
