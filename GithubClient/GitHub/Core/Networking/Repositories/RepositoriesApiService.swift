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
    
    func addRepository(name: String, description: String, isPrivate: Bool, isReadme: Bool,
                       completion: @escaping (Result<Int, Error>) -> Void) {
        
        guard var request = URLRequest(path: "/user/repos", httpMethod: "POST") else { return }
        
        let body: [String: Any] = [
            "name": name,
            "description": description,
            "private": isPrivate,
            "auto_init": isReadme
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = bodyData
        
        URLSession.shared.dataTask(with: request){ _, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            DispatchQueue.main.async {
                completion(.success(response.statusCode))
            }

        }.resume()
    }
}
