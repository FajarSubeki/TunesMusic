//
//  Song.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

struct Song: Identifiable, Decodable {
    var id: Int { trackId }
    
    let trackId: Int
    let trackName: String
    let artistName: String
    let collectionName: String
    let previewUrl: String
    let artworkUrl100: String
}
