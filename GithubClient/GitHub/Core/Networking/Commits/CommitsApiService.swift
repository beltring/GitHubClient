//
//  CommitsApiService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/25/21.
//

import Foundation
import KeychainSwift

class CommitsApiService {
    
    private var dataTask: URLSessionDataTask?
    private let keychain = KeychainSwift()
    
    func getCommitsForDefaultBranch(url: URL, completion: @escaping (Result<[CommitData], Error>) -> Void) {
        
        var request = URLRequest(url: url)
        let acessToken = keychain.get("accessToken")!
        request.addValue("Bearer \(acessToken)", forHTTPHeaderField: "Authorization")
        
        dataTask = URLSession.shared.dataTask(with: request){ data, response, error in
            
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
                let commits = try decoder.decode([CommitData].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(commits))
                }
            }
            catch {
                completion(.failure(error))
            }
        }
        
        dataTask?.resume()
    }
}
