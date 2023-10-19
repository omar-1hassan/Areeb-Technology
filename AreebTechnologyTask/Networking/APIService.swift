//
//  APIService.swift
//  AreebTechnology
//
//  Created by mac on 16/10/2023.
//

import Foundation

class APISercive{
    
    static let shared = APISercive()
    
    private init() {}
    
    //MARK: - Get Creation Date Function
    func getRepositories() async -> Result<[Repository], Error> {

        guard let url = URL(string: "https://api.github.com/repositories") else { 
            return .failure(URLError(.badURL))
        }

        let session = URLSession.shared
        let request = URLRequest(url: url)
        return await withCheckedContinuation { continutation in
            session.dataTask(with: request) { data, response, error in
                guard error == nil else { return }

                guard let data = data else {
                    return
                }

                do {
                    let response = try JSONDecoder().decode([Repository].self, from: data)
                    continutation.resume(returning: .success(response))
                } catch {
                    continutation.resume(returning: .failure(error))
                }
            }.resume()
        }
    }
    
    //MARK: - Get Creation Date Function
    func getCreationDate(for urlString: String?) async -> Repository? {
        let urlString = urlString ?? ""
        guard let url = URL(string: urlString) else {
            return nil
        }
        let session = URLSession.shared
        let request = URLRequest(url: url)
        return await withCheckedContinuation { continuation in
            session.dataTask(with: request) { data, response, error in
                 guard let data = data else {
                     return
                 }
                 do {
                     let response = try JSONDecoder().decode(Repository?.self, from: data)
                     return continuation.resume(returning: response)
                 }
                 catch {
                     print(error.localizedDescription)
                 }
            }.resume()
        }
    }
}

