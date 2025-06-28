//
//  PlayerService.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import Foundation
import AVFoundation

protocol PlayerServiceProtocol {
    func play(url: String, onTimeUpdate: ((Double, Double) -> Void)?, onFinished: (() -> Void)?)
    func pause()
    func resume()
    func stop()
    func seek(to time: Double)
}


class PlayerService : PlayerServiceProtocol{
    private var player: AVPlayer?
    private var currentUrl: String?
    private var timeObserverToken: Any?

    func play(url: String, onTimeUpdate: ((Double, Double) -> Void)? = nil, onFinished: (() -> Void)? = nil) {
        guard let url = URL(string: url) else { return }
        if currentUrl != url.absoluteString {
            player = AVPlayer(url: url)
            currentUrl = url.absoluteString
        } else {
            player?.seek(to: .zero) 
        }
        player?.play()
        
        timeObserverToken = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
            queue: .main
        ) { [weak self] time in
            guard let duration = self?.player?.currentItem?.duration.seconds,
            duration.isFinite else { return }
            let current = time.seconds
            onTimeUpdate?(current, duration)
        }
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { _ in
            onFinished?()
        }
    }

    func pause() {
        player?.pause()
    }
    
    func resume() {
        player?.play()
    }

    func stop() {
        player?.pause()
        player?.seek(to: .zero)

        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }

        player = nil
    }
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        player?.seek(to: cmTime)
    }
    
}
