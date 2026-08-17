//
//  faceCaptureCamera.swift
//  SalesJump
//
//  Created by Saneforce on 17/08/26.
//

import SwiftUI
import AVFoundation
import Vision
import UIKit
import Combine

struct FaceCameraView: View {

    @Environment(\.dismiss) private var dismiss

    let onImageCaptured: (UIImage) -> Void

    @StateObject private var camera = FaceCameraViewModel()

    var body: some View {

        ZStack {

            CameraPreview(session: camera.session)
                .ignoresSafeArea()

            VStack {

                HStack {

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    .padding()

                    Spacer()
                }

                Spacer()

                Text(camera.faceDetected ? "Face Detected ✅" : "Show Your Face")
                    .foregroundColor(.white)
                    .padding()
                    .background(.black.opacity(0.7))
                    .cornerRadius(10)

                Button {
                    camera.capturePhoto()
                } label: {
                    Circle()
                        .fill(camera.faceDetected ? .white : .gray)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 3)
                        )
                }
                .disabled(!camera.faceDetected)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            camera.startSession()
        }
        .onDisappear {
            camera.stopSession()
        }
        .onReceive(camera.$capturedImage) { image in

            guard let image else { return }

            onImageCaptured(image)
            dismiss()
        }
    }
}

final class FaceCameraViewModel: NSObject,
                                 ObservableObject,
                                 AVCaptureVideoDataOutputSampleBufferDelegate,
                                 AVCapturePhotoCaptureDelegate {

    @Published var faceDetected = false
    @Published var capturedImage: UIImage?

    let session = AVCaptureSession()

    private let photoOutput = AVCapturePhotoOutput()

    func startSession() {

        if session.isRunning { return }

        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front
        ) else { return }

        do {

            let input = try AVCaptureDeviceInput(device: camera)

            session.beginConfiguration()

            if session.inputs.isEmpty,
               session.canAddInput(input) {
                session.addInput(input)
            }

            if session.outputs.isEmpty {

                if session.canAddOutput(photoOutput) {
                    session.addOutput(photoOutput)
                }

                let videoOutput = AVCaptureVideoDataOutput()

                videoOutput.setSampleBufferDelegate(
                    self,
                    queue: DispatchQueue(label: "videoQueue")
                )

                if session.canAddOutput(videoOutput) {
                    session.addOutput(videoOutput)
                }
            }

            session.commitConfiguration()

            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
            }

        } catch {
            print("Camera Error:", error)
        }
    }

    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
    }

    func capturePhoto() {

        let settings = AVCapturePhotoSettings()

        photoOutput.capturePhoto(
            with: settings,
            delegate: self
        )
    }

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data)
        else { return }

        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }

    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {

        guard let pixelBuffer =
                CMSampleBufferGetImageBuffer(sampleBuffer)
        else { return }

        let request = VNDetectFaceRectanglesRequest { request, _ in

            let faces =
                request.results as? [VNFaceObservation] ?? []

            DispatchQueue.main.async {
                self.faceDetected = !faces.isEmpty
            }
        }

        let handler =
            VNImageRequestHandler(cvPixelBuffer: pixelBuffer)

        try? handler.perform([request])
    }
}

final class PreviewView: UIView {

    let previewLayer: AVCaptureVideoPreviewLayer

    init(session: AVCaptureSession) {

        previewLayer = AVCaptureVideoPreviewLayer(session: session)

        super.init(frame: .zero)

        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {

        super.layoutSubviews()

        previewLayer.frame = bounds

        guard let connection = previewLayer.connection,
              connection.isVideoOrientationSupported else {
            return
        }

        let orientation = window?.windowScene?.interfaceOrientation

        switch orientation {

        case .landscapeLeft:
            connection.videoOrientation = .landscapeLeft

        case .landscapeRight:
            connection.videoOrientation = .landscapeRight

        case .portraitUpsideDown:
            connection.videoOrientation = .portraitUpsideDown

        default:
            connection.videoOrientation = .portrait
        }
    }
}

struct CameraPreview: UIViewRepresentable {

    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        PreviewView(session: session)
    }

    func updateUIView(
        _ uiView: PreviewView,
        context: Context
    ) {
        uiView.setNeedsLayout()
    }
}
