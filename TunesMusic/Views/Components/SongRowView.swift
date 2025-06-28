//
//  SongRowView.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import SwiftUI
import Kingfisher

struct SongRowView: View {
    let song: Song
    let isPlaying: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            
            KFImage(URL(string: song.artworkUrl100))
                .resizable()
                .placeholder {
                    ProgressView()
                }
                .cancelOnDisappear(true)
                .frame(width: 70, height: 70)
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(song.trackName).fontWeight(.semibold)
                Text(song.artistName).font(.subheadline)
                Text(song.collectionName).font(.caption).foregroundColor(.gray)
            }

            Spacer()
            
            if isPlaying {
                Image(systemName: "waveform")
                    .foregroundColor(.blue)
                    .font(.system(size: 32))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
