//
//  GitHubAPI.swift
//  GithubClient
//
//  Created by user on 4/9/21.
//

import Foundation
import Moya

enum GitHubAPI {
    case getUserRepositories
    case getStarredRepositories
    case getSearchRepositories(String)
    case getSearchUsers(String)
    case getUser
    case getIssues(String)
    case addRepositories(RepositoryData)
    case getCommits(String)
    case getPullRequests(String)
}

// MARK: Moya Extension
extension GitHubAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .getUserRepositories, .addRepositories:
            return "user/repos"
        case .getStarredRepositories:
            return "user/starred"
        case .getSearchRepositories:
            return "search/repositories"
        case .getSearchUsers:
            return "search/users"
        case .getUser:
            return "user"
        case .getIssues:
            return "user/issues"
        case .getCommits(let commitPath):
            return commitPath
        case .getPullRequests(let pullPath):
            return pullPath
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addRepositories:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getUserRepositories:
            return .requestParameters(parameters: ["per_page" : "100", "sort" : "created"], encoding: URLEncoding.queryString)
        case .getStarredRepositories:
            return .requestParameters(parameters: ["per_page" : "100"], encoding: URLEncoding.queryString)
        case .getSearchRepositories(let searchText), .getSearchUsers(let searchText):
            return .requestParameters(parameters: ["q" : searchText, "per_page" : "100"], encoding: URLEncoding.queryString)
        case .getIssues(let filter):
            return .requestParameters(parameters: ["filter" : filter], encoding: URLEncoding.queryString)
        case .addRepositories(let data):
            return .requestParameters(parameters: ["name": data.name,
                                                   "description": data.description,
                                                   "private": data.isPrivate,
                                                   "auto_init": data.isReadme], encoding: JSONEncoding.default)
        case .getCommits:
            return .requestParameters(parameters: ["per_page" : "100"], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let accessToken = AuthorizeData.shared.accessToken!
        return ["Authorization": "Bearer \(accessToken)"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
