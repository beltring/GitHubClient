//
//  RepositoriesApiService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/24/21.
//

import Foundation

class RepositoriesApiService {
    
    func getRepositoriesForAuthUser(completion: @escaping (Result<[Repository], Error>) -> Void) {
        
        let queryItems = [
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "sort", value: "created")
        ]
        
        guard let request = URLRequest(queryItem: queryItems, path: "user/repos") else { return }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
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
    
    func getStarredRepositories(completion: @escaping (Result<[Repository], Error>) -> Void) {
        
        let queryItems = [URLQueryItem(name: "per_page", value: "100")]
        
        guard let request = URLRequest(queryItem: queryItems, path: "user/starred") else { return }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
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
