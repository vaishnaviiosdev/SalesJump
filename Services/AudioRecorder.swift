//
//  AudioRecorder.swift
//  SalesJump
//
//  Created by Saneforce on 19/08/26.
//

import Foundation
import AVFoundation
import Combine

import SwiftUI


final class AudioRecorder: NSObject, ObservableObject {

    @Published var isRecording = false
    @Published var audioLevel: CGFloat = 0
    @Published var recordedAudioURL: URL?

    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?

    func startRecording() {

        do {

            let session = AVAudioSession.sharedInstance()

            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)

            let fileName = "\(UUID().uuidString).m4a"

            let url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            )[0]
            .appendingPathComponent(fileName)

            recordedAudioURL = url

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(
                url: url,
                settings: settings
            )

            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()

            isRecording = true

            timer = Timer.scheduledTimer(
                withTimeInterval: 0.05,
                repeats: true
            ) { [weak self] _ in

                guard let self = self,
                      let recorder = self.audioRecorder else {
                    return
                }

                recorder.updateMeters()

                let power = recorder.averagePower(forChannel: 0)

                let normalizedLevel = max(
                    0.05,
                    CGFloat((power + 60) / 60)
                )

                DispatchQueue.main.async {
                    self.audioLevel = normalizedLevel
                }
            }

        } catch {
            print("Recording Error:", error.localizedDescription)
        }
    }

    func stopRecording() {

        timer?.invalidate()
        timer = nil

        audioRecorder?.stop()

        isRecording = false
        audioLevel = 0

        if let url = recordedAudioURL {
            print("Audio Saved:", url.path)
        }
    }
}

struct VoiceWaveView: View {

    let level: CGFloat

    var body: some View {

        HStack(spacing: 3) {

            ForEach(0..<6, id: \.self) { index in

                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.red)
                    .frame(
                        width: 4,
                        height: max(
                            8,
                            (level * 35) + CGFloat(index * 2)
                        )
                    )
                    .animation(
                        .easeInOut(duration: 0.1),
                        value: level
                    )
            }
        }
    }
}

