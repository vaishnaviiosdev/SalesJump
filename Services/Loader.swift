//
//  Loader.swift
//  SalesJump
//
//  Created by Saneforce on 21/08/26.
//

import SwiftUI
import WebKit

struct GIFView: UIViewRepresentable {

    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false

        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            webView.load(
                data ?? Data(),
                mimeType: "image/gif",
                characterEncodingName: "UTF-8",
                baseURL: URL(fileURLWithPath: path)
            )
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct Loader: View {

    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            GIFView(gifName: "progress_dialog")
                .frame(
                    width: isPad ? 180 : 120,
                    height: isPad ? 180 : 120
                )
        }
    }
}
