//
//  ToastManager.swift
//  SalesJump
//
//  Created by Saneforce on 14/08/26.
//

import Foundation
import Combine
import SwiftUI

final class Toastmanager: ObservableObject {
    static let shared = Toastmanager()

    @Published var isShowing = false
    @Published var message = ""

    func show(_ message: String) {
        self.message = message

        withAnimation {
            isShowing = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.isShowing = false
            }
        }
    }
}
