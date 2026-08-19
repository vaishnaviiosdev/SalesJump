//
//  AudioPlayerManager.swift
//  SalesJump
//
//  Created by Saneforce on 19/08/26.
//

import Foundation
import AVFoundation
import SwiftUI
import Combine

final class AudioPlayerManager: NSObject, ObservableObject {

    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0

    private var player: AVAudioPlayer?
    private var timer: Timer?

    func loadAudio(url: URL) {

        do {

            player = try AVAudioPlayer(contentsOf: url)

            duration = player?.duration ?? 0
            player?.prepareToPlay()

        } catch {
            print(error.localizedDescription)
        }
    }

    func playPause() {

        guard let player = player else { return }

        if player.isPlaying {

            player.pause()
            isPlaying = false

            timer?.invalidate()

        } else {

            player.play()
            isPlaying = true

            timer = Timer.scheduledTimer(
                withTimeInterval: 0.1,
                repeats: true
            ) { [weak self] _ in

                guard let self = self,
                      let player = self.player else { return }

                self.currentTime = player.currentTime

                if !player.isPlaying {
                    self.isPlaying = false
                    self.timer?.invalidate()
                }
            }
        }
    }

    func stop() {

        player?.stop()
        player?.currentTime = 0

        currentTime = 0
        isPlaying = false

        timer?.invalidate()
    }

    func deleteAudio(at path: String) {

        stop()

        do {
            try FileManager.default.removeItem(
                atPath: path
            )
        } catch {
            print(error.localizedDescription)
        }
    }

    func timeString(_ time: TimeInterval) -> String {

        let minutes = Int(time) / 60
        let seconds = Int(time) % 60

        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }
}
