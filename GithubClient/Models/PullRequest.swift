//
//  PullRequest.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/28/21.
//

import Foundation

struct PullRequest: Decodable {
    let title: String?
    let number: Int?
    let createdDate: String?
    let url: String?
    let issueUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, number
        case createdDate = "created_at"
        case url = "html_url"
        case issueUrl = "issue_url"
    }
}
