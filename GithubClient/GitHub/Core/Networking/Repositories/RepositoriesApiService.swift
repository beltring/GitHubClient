//
//  RepositoriesApiService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/24/21.
//

import Foundation
import KeychainSwift

class RepositoriesApiService {
    
    private var dataTask: URLSessionDataTask?
    private let keychain = KeychainSwift()
    
    func getRepositoriesForAuthUser(completion: @escaping (Result<[Repository], Error>) -> Void) {
        
        guard let url = URL.github?.appendingPathComponent("user/repos") else { return }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }

        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "sort", value: "created")
        ]
        var request = URLRequest(url: urlComponents.url!)
        let acessToken = keychain.get("accessToken")!
        // Set headers
        request.addValue("Bearer \(acessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Repository].self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
