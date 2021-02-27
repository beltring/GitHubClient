//
//  IssuesApiService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/26/21.
//

import Foundation
import KeychainSwift

class IssuesApiService {
    private var dataTask: URLSessionDataTask?
    private let keychain = KeychainSwift()
    
    func getIssues(filter: String = "all", completion: @escaping (Result<[Issue], Error>) -> Void) {
        guard let url = URL.github?.appendingPathComponent("user/issues") else { return }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "filter", value: filter)
        ]
        var request = URLRequest(url: urlComponents.url!)
        let acessToken = keychain.get("accessToken")!
        // Set headers
        request.addValue("Bearer \(acessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _ , error in
         
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
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
                completion(.failure(error))
            }

        }.resume()
    }
}
