//
//  PullRequestApiService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/28/21.
//

import Foundation

class PullRequestApiService {
    func getPullRequest(url: URL, completion: @escaping (Result<[PullRequest], Error>) -> Void) {
        
        let accessToken = AuthorizeData.shared.accessToken!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let pullRequests = try decoder.decode([PullRequest].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(pullRequests))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
