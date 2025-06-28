//
//  APIError.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

enum APIError: Error, LocalizedError {
    case invalidURL
    case emptyData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL tidak valid."
        case .emptyData:
            return "Data kosong dari server."
        }
    }
}
