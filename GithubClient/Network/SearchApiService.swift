//
//  SearchApiService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/1/21.
//

import Foundation

class SearchApiService {
    func getRepositoriesBySearchText(searchText: String, completion: @escaping (Result<RepositoriesData, Error>) -> Void) {
        
        let queryItems = [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "per_page", value: "100")
        ]
        
        guard let request = URLRequest(queryItem: queryItems, path: "/search/repositories") else { return }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let repositories = try decoder.decode(RepositoriesData.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(repositories))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
    
    func getUsersBySearchText(searchText: String, completion: @escaping (Result<UsersData, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "per_page", value: "100")
        ]
        
        guard let request = URLRequest(queryItem: queryItems, path: "/search/users") else { return }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let users = try decoder.decode(UsersData.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
