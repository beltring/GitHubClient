//
//  SearchApiService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/1/21.
//

import Foundation

class SearchApiService {
    func getRepositoriesBySearchText(searchText: String, completion: @escaping (Result<RepositoriesData, Error>) -> Void) {
        guard let url = URL.github?.appendingPathComponent("/search/repositories") else { return }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "per_page", value: "100")
        ]
        
        let accessToken = AuthorizeData.shared.accessToken!
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let repositories = try decoder.decode(RepositoriesData.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(repositories))
                }
            }
            catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
