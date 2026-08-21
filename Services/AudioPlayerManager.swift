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

    func deleteAudio(at path: String) async -> Bool {

        stop()

        do {

            if FileManager.default.fileExists(atPath: path) {
                try FileManager.default.removeItem(atPath: path)
                print("Local Audio Deleted")
            }

            let isSuccess = await deleteFile()

            if isSuccess {
                print("Server Audio Delete Success")
            } else {
                print("Server Audio Delete Failed")
            }

            return isSuccess

        } catch {

            print("Delete Error:", error.localizedDescription)
            return false
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
    
    
    func deleteFile() async -> Bool {

        var components = URLComponents(string: "\(APIClient.shared.Url)mediadelete")!

        components.queryItems = [
            URLQueryItem(name: "filePath", value: AudioFile.shared.filename)
        ]

        guard let url = components.url else { return false }

        print("Delete URL:", url)

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(SessionManager.shared.JWT_Token)",
                         forHTTPHeaderField: "Authorization")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return false
            }

            print("Delete Status Code:", httpResponse.statusCode)

            return (200...299).contains(httpResponse.statusCode)

        } catch {
            print("Delete Error:", error.localizedDescription)
            return false
        }
    }}
