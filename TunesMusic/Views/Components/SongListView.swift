//
//  SongListView.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import SwiftUI

struct SongListView: View {
    let songs: [Song]
    let currentPlayingId: Int?
    let onSelect: (Song) -> Void

    var body: some View {
        List(songs) { song in
            SongRowView(
                song: song,
                isPlaying: currentPlayingId == song.trackId,
                onTap: { onSelect(song) }
            )
            .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        }
        .listStyle(PlainListStyle())
    }
}
