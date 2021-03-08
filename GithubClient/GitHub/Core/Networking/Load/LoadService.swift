//
//  LoadService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/27/21.
//

import Foundation
import UIKit

class LoadService {
    func getImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                print("Empty data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    completion(.success(image))
                }
            }
        }.resume()
    }
}
