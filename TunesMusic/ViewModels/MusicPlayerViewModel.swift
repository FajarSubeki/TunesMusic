//
//  MusicPlayerViewModel.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import Foundation

class MusicPlayerViewModel: ObservableObject {

    @Published var searchQuery: String = ""
    @Published var songs: [Song] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var currentSong: Song? = nil
    @Published var isPlaying: Bool = false
    @Published var showEmptyState: Bool = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var isFinished: Bool = false
    
    let apiService: APIServiceProtocol
    let playerService: PlayerServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService(),
        playerService: PlayerServiceProtocol = PlayerService()) {
        self.apiService = apiService
        self.playerService = playerService
    }

    func search() {
        guard !searchQuery.isEmpty else { return }

        isLoading = true
        songs = []
        showEmptyState = false

        apiService.fetchSongs(query: searchQuery) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let songs):
                    self?.songs = songs
                    self?.showEmptyState = songs.isEmpty
                    if songs.isEmpty {
                        self?.errorMessage = "\(AppConstants.emptyData) \"\(self?.searchQuery ?? "")\"."
                    }
                case .failure(let error):
                    self?.songs = []
                    self?.errorMessage = error.localizedDescription
                    self?.showEmptyState = true
                }
            }
        }
    }

    func play(song: Song) {
        currentSong = song
        isPlaying = true
        isFinished = false

        playerService.play(
            url: song.previewUrl,
            onTimeUpdate: { [weak self] current, duration in
                self?.currentTime = current
                self?.duration = duration
            },
            onFinished: { [weak self] in
                self?.isFinished = true
                self?.isPlaying = false
            }
        )
    }

    func pause() {
        playerService.pause()
        isPlaying = false
    }

    func resume() {
        playerService.resume()
        isPlaying = true
    }

    func stop() {
        playerService.stop()
        isPlaying = false
        currentSong = nil
    }
    
    func togglePlayPause() {
        guard let song = currentSong else { return }

        if isPlaying {
            pause()
        } else {
            if isFinished {
                play(song: song)
            } else {
                resume()
            }
        }
    }

    func next() {
        guard let current = currentSong,
              let index = songs.firstIndex(where: { $0.trackId == current.trackId }),
              index + 1 < songs.count else { return }
        play(song: songs[index + 1])
    }

    func previous() {
        guard let current = currentSong,
              let index = songs.firstIndex(where: { $0.trackId == current.trackId }),
              index > 0 else { return }
        play(song: songs[index - 1])
    }

    func seek(to time: Double) {
        playerService.seek(to: time)
    }
    
    func clearSearchResults() {
        songs = []
    }

}
