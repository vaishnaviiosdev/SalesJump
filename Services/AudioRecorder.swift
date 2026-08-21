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


class AudioFile {
    
    static let shared = AudioFile()
    
    var filename:String = ""
    
    
}

struct UploadResponse: Codable {
    let message: String
    let audio: String
}

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

    func stopRecording() async -> Bool {

        timer?.invalidate()
        timer = nil

        audioRecorder?.stop()

        isRecording = false
        audioLevel = 0

        guard let url = recordedAudioURL else {
            return false
        }

        print("Audio Saved:", url.path)

        let isSuccess = await SaveAudio()

        if isSuccess {
            print("Audio Upload Success")
        } else {
            print("Audio Upload Failed")
        }

        return isSuccess
    }
    
    
    func SaveAudio() async -> Bool {

        guard let audioURL = recordedAudioURL else {
            return false
        }

        guard let url = URL(string: "\(APIClient.shared.Url)audioupload") else {
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(SessionManager.shared.JWT_Token)",forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)",forHTTPHeaderField: "Content-Type")

        var data = Data()

        do {

            let audioData = try Data(contentsOf: audioURL)

            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"files\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
            data.append(audioData)
            data.append("\r\n".data(using: .utf8)!)
            data.append("--\(boundary)--\r\n".data(using: .utf8)!)

            let (responseData, response) = try await URLSession.shared.upload(
                for: request,
                from: data
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                return false
            }

            print("Status Code:", httpResponse.statusCode)

            do {
                let result = try JSONDecoder().decode(UploadResponse.self, from: responseData)

                print("Message:", result.message)
                print("Audio Name:", result.audio)

                AudioFile.shared.filename = result.audio

            } catch {
                print("Decode Error:", error)
            }

            return (200...299).contains(httpResponse.statusCode)

        } catch {
            print("Audio Upload Error:", error.localizedDescription)
            return false
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

