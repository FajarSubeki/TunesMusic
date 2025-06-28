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
    @Published var errorMessage: String? = nil
    @Published var currentSong: Song? = nil
    @Published var isPlaying: Bool = false
    @Published var showEmptyState: Bool = false
    
    private let apiService: APIServiceProtocol
    private let playerService: PlayerServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService(),
        playerService: PlayerServiceProtocol = PlayerService()) {
        self.apiService = apiService
        self.playerService = playerService
    }

    func search() {
        guard !searchQuery.isEmpty else { return }

        isLoading = true
        errorMessage = nil
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
        playerService.play(url: song.previewUrl)
        isPlaying = true
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
}
