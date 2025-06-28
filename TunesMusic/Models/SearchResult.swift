//
//  SearchResult.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Song]
}
