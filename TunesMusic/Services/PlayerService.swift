//
//  PlayerService.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import Foundation
import AVFoundation

protocol PlayerServiceProtocol {
    func play(url: String)
    func pause()
    func resume()
    func stop()
}


class PlayerService : PlayerServiceProtocol{
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
    
    func resume() {
        player?.play()
    }

    func stop() {
        player = nil
        currentUrl = nil
    }
}
