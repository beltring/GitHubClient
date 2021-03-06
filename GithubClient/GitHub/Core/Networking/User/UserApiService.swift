//
//  UserApiService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/26/21.
//

import Foundation

class UserApiService {
    
    func getUserInformation(completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let request = URLRequest(queryItem: [], path: "user") else { return }
        
        URLSession.shared.dataTask(with: request){ data, _, error in
            
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
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
