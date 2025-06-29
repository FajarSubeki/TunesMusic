//
//  ErrorMessageBuilder.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 29/06/25.
//

struct ErrorMessageBuilder {
    
    static func emptyResult(for query: String) -> String {
        return "\(AppConstants.emptyData) \"\(query)\"."
    }

    static func apiError(_ error: Error) -> String {
        return error.localizedDescription
    }
    
}

