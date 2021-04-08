//
//  CommitsApiService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/25/21.
//

import Foundation

class CommitsApiService {
    
    func getCommitsForDefaultBranch(url: String, completion: @escaping (Result<[CommitData], Error>) -> Void) {
        
        guard var urlComponents = URLComponents(string: url) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "100")
        ]
        
        let accessToken = AuthorizeData.shared.accessToken!
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let commits = try decoder.decode([CommitData].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(commits))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
