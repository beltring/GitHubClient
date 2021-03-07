//
//  URLRequest+GithubClient.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/6/21.
//

import Foundation

extension URLRequest {
    init?(queryItem: [URLQueryItem] = [], path: String, httpMethod: String = "GET", cachePolicy: CachePolicy = .useProtocolCachePolicy,
          timeInterval: TimeInterval = 60) {
        guard let url = URL.github?.appendingPathComponent(path) else { return nil }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComponents.queryItems = queryItem
        
        let accessToken = AuthorizeData.shared.accessToken!
        
        self.init(url: urlComponents.url!, cachePolicy: cachePolicy, timeoutInterval: timeInterval)
        addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        self.httpMethod = httpMethod
    }
    
    
}
