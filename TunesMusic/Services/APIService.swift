//
//  APIService.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import Foundation

protocol APIServiceProtocol {
    func fetchSongs(query: String, completion: @escaping (Result<[Song], Error>) -> Void)
}

class APIService : APIServiceProtocol{
    
    func fetchSongs(query: String, completion: @escaping (Result<[Song], Error>) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(APIConstants.baseURL)\(APIConstants.searchEndpoint)?term=\(encodedQuery)&entity=song"

        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.emptyData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(SearchResult.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded.results))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
