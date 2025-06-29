//
//  MusicPlayerViewModelTests.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import XCTest
@testable import TunesMusic

final class MusicPlayerViewModelTests: XCTestCase {

    class MockAPIService: APIServiceProtocol {
        var result: Result<[Song], Error>?

        func fetchSongs(query: String, completion: @escaping (Result<[Song], Error>) -> Void) {
            if let result = result {
                completion(result)
            }
        }
    }

    class MockPlayerService: PlayerServiceProtocol {
        var didPlay = false
        var didPause = false
        var didResume = false
        var didStop = false
        var didSeek = false
        var lastSeekTime: Double?
        var lastPlayedUrl: String?

        var onTimeUpdateCalled = false
        var onFinishedCalled = false

        func play(url: String, onTimeUpdate: ((Double, Double) -> Void)? = nil, onFinished: (() -> Void)? = nil) {
            didPlay = true
            lastPlayedUrl = url

            onTimeUpdate?(10.0, 120.0)
            onTimeUpdateCalled = true

            onFinished?()
            onFinishedCalled = true
        }

        func pause() { didPause = true }
        func resume() { didResume = true }
        func stop() { didStop = true }
        func seek(to time: Double) {
            didSeek = true
            lastSeekTime = time
        }
    }

    private let sampleSong = Song(
        trackId: 123,
        trackName: "Love Story",
        artistName: "Taylor Swift",
        collectionName: "Fearless",
        previewUrl: "https://example.com/lovestory.mp3",
        artworkUrl100: "https://example.com/art.jpg"
    )

    func testSearchSuccess() {
        let mockAPI = MockAPIService()
        let mockPlayer = MockPlayerService()
        mockAPI.result = .success([sampleSong])
        let viewModel = MusicPlayerViewModel(apiService: mockAPI, playerService: mockPlayer)
        viewModel.searchQuery = "taylor"

        let expectation = XCTestExpectation(description: "Search success")

        viewModel.search()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(viewModel.songs.count, 1)
            XCTAssertEqual(viewModel.songs.first?.trackName, "Love Story")
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.showEmptyState)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testSearchFailure() {
        let mockAPI = MockAPIService()
        let mockPlayer = MockPlayerService()
        mockAPI.result = .failure(APIError.invalidURL)
        let viewModel = MusicPlayerViewModel(apiService: mockAPI, playerService: mockPlayer)
        viewModel.searchQuery = "fail"

        let expectation = XCTestExpectation(description: "Search failure")

        viewModel.search()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(viewModel.songs.count, 0)
            XCTAssertTrue(viewModel.showEmptyState)
            XCTAssertNotNil(viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testSearchEmptyResult() {
        let mockAPI = MockAPIService()
        let mockPlayer = MockPlayerService()
        mockAPI.result = .success([])
        let viewModel = MusicPlayerViewModel(apiService: mockAPI, playerService: mockPlayer)
        viewModel.searchQuery = "unknown"

        let expectation = XCTestExpectation(description: "Search empty")

        viewModel.search()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(viewModel.songs.count, 0)
            XCTAssertTrue(viewModel.showEmptyState)
            XCTAssertNotNil(viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testPlaySong() {
        let viewModel = MusicPlayerViewModel(
            apiService: MockAPIService(),
            playerService: MockPlayerService()
        )

        let mockPlayer = viewModel.playerService as! MockPlayerService
        viewModel.play(song: sampleSong)

        XCTAssertEqual(viewModel.currentSong?.trackId, sampleSong.trackId)
        XCTAssertTrue(viewModel.isPlaying)
        XCTAssertTrue(mockPlayer.didPlay)
        XCTAssertTrue(mockPlayer.onTimeUpdateCalled)
        XCTAssertTrue(mockPlayer.onFinishedCalled)
    }

    func testPauseSong() {
        let viewModel = MusicPlayerViewModel(
            apiService: MockAPIService(),
            playerService: MockPlayerService()
        )

        let mockPlayer = viewModel.playerService as! MockPlayerService
        viewModel.pause()

        XCTAssertFalse(viewModel.isPlaying)
        XCTAssertTrue(mockPlayer.didPause)
    }

    func testResumeSong() {
        let viewModel = MusicPlayerViewModel(
            apiService: MockAPIService(),
            playerService: MockPlayerService()
        )

        let mockPlayer = viewModel.playerService as! MockPlayerService
        viewModel.resume()

        XCTAssertTrue(viewModel.isPlaying)
        XCTAssertTrue(mockPlayer.didResume)
    }

    func testStopSong() {
        let viewModel = MusicPlayerViewModel(
            apiService: MockAPIService(),
            playerService: MockPlayerService()
        )

        let mockPlayer = viewModel.playerService as! MockPlayerService
        viewModel.stop()

        XCTAssertNil(viewModel.currentSong)
        XCTAssertFalse(viewModel.isPlaying)
        XCTAssertTrue(mockPlayer.didStop)
    }

    func testSeekSong() {
        let viewModel = MusicPlayerViewModel(
            apiService: MockAPIService(),
            playerService: MockPlayerService()
        )

        let mockPlayer = viewModel.playerService as! MockPlayerService
        viewModel.seek(to: 45.0)

        XCTAssertTrue(mockPlayer.didSeek)
        XCTAssertEqual(mockPlayer.lastSeekTime, 45.0)
    }

    func testTogglePlayPause() {
        let viewModel = MusicPlayerViewModel(
            apiService: MockAPIService(),
            playerService: MockPlayerService()
        )

        let mockPlayer = viewModel.playerService as! MockPlayerService
        viewModel.play(song: sampleSong)

        viewModel.togglePlayPause()
        XCTAssertFalse(viewModel.isPlaying)
        XCTAssertTrue(mockPlayer.didPause)

        viewModel.togglePlayPause()
        XCTAssertTrue(viewModel.isPlaying)
        XCTAssertTrue(mockPlayer.didResume)
    }
}

