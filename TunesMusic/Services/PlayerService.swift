//
//  PlayerService.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import Foundation
import AVFoundation

class PlayerService {
    private var player: AVPlayer?
    private var currentUrl: String?

    func play(url: String) {
        guard let url = URL(string: url) else { return }
        if currentUrl != url.absoluteString {
            player = AVPlayer(url: url)
            currentUrl = url.absoluteString
        }
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        player = nil
        currentUrl = nil
    }
}
