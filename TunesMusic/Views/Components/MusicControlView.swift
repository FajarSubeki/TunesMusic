//
//  MusicControlView.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import SwiftUI

struct MusicControlView: View {
    let isPlaying: Bool
    let currentTime: Double
    let duration: Double
    let onPlayPause: () -> Void
    let onStop: () -> Void
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onSeek: (Double) -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 40) {
                Button(action: onPrevious) {
                    Image(systemName: "backward.end.fill")
                }

                Button(action: onPlayPause) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 36))
                }

                Button(action: onNext) {
                    Image(systemName: "forward.end.fill")
                }
            }
            .font(.title2)

            Slider(value: Binding(
                get: { currentTime },
                set: { newValue in
                    onSeek(newValue)
                }
            ), in: 0...duration)
            .accentColor(.blue)

            HStack {
                Text(formatTime(currentTime))
                Spacer()
                Text(formatTime(duration))
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
    }

    // Helper to format seconds into MM:SS
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}


