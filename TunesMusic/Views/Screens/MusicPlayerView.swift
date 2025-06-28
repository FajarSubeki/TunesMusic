//
//  MusicPlayerView.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import SwiftUI

struct MusicPlayerView: View {
    @StateObject private var viewModel = MusicPlayerViewModel()
    @State private var showErrorToast = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                SearchBarView(text: $viewModel.searchQuery, onSearch: viewModel.search)

                Spacer(minLength: 0)

                if viewModel.songs.isEmpty && !viewModel.isLoading && viewModel.searchQuery.isEmpty {
                    VStack {
                        Text(AppConstants.defaultSearch)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else if viewModel.showEmptyState {
                    VStack {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    SongListView(
                        songs: viewModel.songs,
                        currentPlayingId: viewModel.currentSong?.trackId,
                        onSelect: { song in
                            if viewModel.currentSong?.trackId == song.trackId && viewModel.isPlaying {
                                viewModel.pause()
                            } else {
                                viewModel.play(song: song)
                            }
                        }
                    )
                }

                Spacer(minLength: 0)

                if let _ = viewModel.currentSong {
                    Divider()
                    MusicControlView(
                        isPlaying: viewModel.isPlaying,
                        currentTime: viewModel.currentTime,
                        duration: viewModel.duration,
                        onPlayPause: viewModel.togglePlayPause,
                        onStop: viewModel.stop,
                        onPrevious: viewModel.previous,
                        onNext: viewModel.next,
                        onSeek: viewModel.seek(to:)
                    )
                    .padding(.bottom, 8)
                }
            }

            if viewModel.isLoading {
                LoadingView()
            }

            if showErrorToast {
                ErrorToastView(message: viewModel.errorMessage)
            }
        }
        .toast(message: viewModel.errorMessage, isVisible: $showErrorToast)
        .onChange(of: viewModel.errorMessage, initial: false) { _, newError in
            withAnimation {
                showErrorToast = true
            }
        }
    }
    
}



#Preview {
    MusicPlayerView()
}
