//
//  Helper.swift
//  SalesJump
//
//  Created by San eforce on 27/07/26.
//

import SwiftUI
import Foundation
import Combine

extension Font {
    static func poppinsRegular(_ size: CGFloat) -> Font {
        .custom("WorkSans-Regular", size: size)
    }

    static func poppinsMedium(_ size: CGFloat) -> Font {
        .custom("WorkSans-Medium", size: size)
    }

    static func poppinsBold(_ size: CGFloat) -> Font {
        .custom("WorkSans-Bold", size: size)
    }
    
    static func poppinsSemiBold(_ size: CGFloat) -> Font {
        .custom("WorkSans-SemiBold", size: size)
    }
    
    static func poppinsThin(_ size: CGFloat) -> Font {
        .custom("WorkSans-Light", size: size)
    }
    
    static func poppinsExtraLight(_ size: CGFloat) -> Font {
        .custom("WorkSans-ExtraBold", size: size)
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func loadingOverlay(_ isLoading: Bool, text: String = "Loading...") -> some View {
        self.modifier(LoadingOverlay(isLoading: isLoading, loadingText: text))
    }
    
    func toast(_ toastManager: ToastManager) -> some View {
        self.modifier(ToastModifier(toastManager: toastManager))
    }
//    
//    func customAlert(_ manager: CustomAlertManager) -> some View {
//        self.modifier(CustomAlertModifier(manager: manager))
//    }
//    
//    func borderedTab(isSelected: Bool, selectedColor: Color = .blue, leading: CGFloat = 12, vertical: CGFloat = 8, cornerR: CGFloat = 12, lineWidth: CGFloat = 2) -> some View {
//        self.modifier(BorderedTabModifier(isSelected: isSelected, selectedColor: selectedColor, cornerRadius: cornerR, lineWidth: lineWidth, leadingPadding: leading, verticalPadding: vertical))
//    }
    
    func cardStyle(
        cornerRadius: CGFloat = 12,
        backgroundColor: Color = .white
    ) -> some View {
        self.modifier(CardStyleModifier(cornerRadius: cornerRadius, backgroundColor: backgroundColor))
    }
    
    func regularTextStyle(size: CGFloat = 14, foreground: Color = .black, fontWeight: Font.Weight = .regular) -> some View {
        self.font(.system(size: size)).foregroundColor(foreground).fontWeight(fontWeight)
    }
}

struct CardStyleModifier: ViewModifier {
    var cornerRadius: CGFloat = 12
    var backgroundColor: Color = .white
    var borderColor: Color = Color.black.opacity(0.2) //0.5
    var shadowColor: Color = Color.black.opacity(0.17)
    var shadowRadius: CGFloat = 4
    var shadowX: CGFloat = 0
    var shadowY: CGFloat = 2

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 0.5) //0.1
            )
            .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct CircularLoader: View {
    @State private var isAnimating = false
    var loadingText: String = "Loading..."

    var body: some View {
        VStack(spacing: 10) {
            Circle()
                .trim(from: 0.0, to: 0.7) // Shows 70% of the circle
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(.appPrimary)
                .frame(width: 30, height: 30)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
    }
}

struct LoadingOverlay: ViewModifier {
    let isLoading: Bool
    let loadingText: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    CircularLoader(loadingText: loadingText)
                }
                .transition(.opacity)
            }
        }
    }
}

final class ToastManager: ObservableObject {
    @Published var show = false
    @Published var message = ""

    func showToast(_ message: String) {
        self.message = message
        self.show = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.show = false
            }
        }
    }
}

struct ToastModifier: ViewModifier {

    @ObservedObject var toastManager: ToastManager

    func body(content: Content) -> some View {
        ZStack {
            content

            if toastManager.show {
                VStack {
                    Spacer()
                    ToastView(message: toastManager.message)
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }
}

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.poppinsMedium(15))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.8))
            .cornerRadius(8)
            .shadow(radius: 5)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.3), value: message)
    }
}

func isValidPassword(_ password: String) -> Bool {

    let passwordRegex =
    "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&^#()_+=\\-]).{8,}$"

    return NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        .evaluate(with: password)
}

//
//struct CustomAlertModifier: ViewModifier {
//    @ObservedObject var manager: CustomAlertManager
//
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//            CustomAlertView(manager: manager)
//        }
//    }
//}
