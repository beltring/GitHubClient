//
//  IssuesApiService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/26/21.
//

import Foundation

class IssuesApiService {
    
    func getIssues(filter: String = "all", completion: @escaping (Result<[Issue], Error>) -> Void) {
    
        let queryItems = [URLQueryItem(name: "filter", value: filter)]
        
        guard let request = URLRequest(queryItem: queryItems, path: "user/issues") else { return }
        
        URLSession.shared.dataTask(with: request) { data, _ , error in
         
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
                let issues = try decoder.decode([Issue].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(issues))
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
