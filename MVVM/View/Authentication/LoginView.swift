//
//  LoginView.swift
//  SalesJump
//
//  Created by San eforce on 27/07/26.
//

import SwiftUI

struct Login_TxtfieldName: View {
    @Binding var titleName: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(titleName)
                .font(.poppinsMedium(12))
                .foregroundColor(.appTextGrey)
            
            Text("*")
                .foregroundColor(.appRed)
        }
    }
}

struct LoginView: View {
    @StateObject private var vm = AuthenticationViewModel()
    @EnvironmentObject var toastManager: ToastManager
    @EnvironmentObject var router: AppRouter
    @State private var userName = ""
    @State private var password = ""

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    //@State private var navigateToSettings = false
    
//    var body: some View {
//
////        GeometryReader { geo in
////            
////            
////
////                
////
////            let isLandscape = geo.size.width > geo.size.height
////            let isSmallScreen = geo.size.height < 700
////            let shouldScroll = isLandscape || isSmallScreen
////
////            ZStack {
////                Color.white
////                    .ignoresSafeArea()
////
////                if shouldScroll {
////                    ScrollView(.vertical, showsIndicators: false) {
////                        LoginContent(
////                            geo: geo,
////                            userName: $userName,
////                            password: $password,
////                            loginAction: validateLogin
////                        )
////                    }
////                }
////                else {
////                    LoginContent(
////                        geo: geo,
////                        userName: $userName,
////                        password: $password,
////                        loginAction: validateLogin
////                    )
////                }
////                toastOverlay
////            }
////            .toast(toastManager)
////            .loadingOverlay(isLoading, text: "Loading...")
//////            onAppear {
//////                
//////                let screenHeight = geo.size.height
//////                let screenWidth = geo.size.width
//////
//////                print("Width: \(screenWidth)")
//////                print("Height: \(screenHeight)")
//////            }
//////            .navigationDestination(isPresented: $navigateToSettings) {
//////                    SettingsView()
//////            }
////        }
//        
//        GeometryReader { geo in
//
//            let isLandscape = geo.size.width > geo.size.height
//            let isSmallScreen = geo.size.height < 700
//            let shouldScroll = isLandscape || isSmallScreen
//
//            ZStack {
//                Color.white
//                    .ignoresSafeArea()
//
//                if shouldScroll {
//                    ScrollView(.vertical, showsIndicators: false) {
//                        LoginContent(
//                            geo: geo,
//                            userName: $userName,
//                            password: $password,
//                            loginAction: validateLogin
//                        )
//                    }
//                } else {
//                    LoginContent(
//                        geo: geo,
//                        userName: $userName,
//                        password: $password,
//                        loginAction: validateLogin
//                    )
//                }
//
//                toastOverlay
//            }
//            .onAppear {
//                print("Width: \(geo.size.width)")
//                print("Height: \(geo.size.height)")
//            }
//            .onChange(of: geo.size.height) { newHeight in
//                print("Height Changed: \(newHeight)")
//            }
//            .toast(toastManager)
//            .loadingOverlay(isLoading, text: "Loading...")
//        }
//    }
    
    var body: some View {
        GeometryReader { geo in

            let screenHeight = UIScreen.main.bounds.height
            let isLandscape = geo.size.width > geo.size.height
            let isSmallScreen = screenHeight < 700

            ZStack {
                Color.white
                    .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    LoginContent(
                        geo: geo,
                        userName: $userName,
                        password: $password,
                        loginAction: validateLogin
                    )
                }
                .scrollDisabled(!(isLandscape || isSmallScreen))

                toastOverlay
            }
            .onChange(of: vm.loginSuccess) { success in
                if success {
                    router.loginSuccess()
                }
            }
            .toast(toastManager)
            .loadingOverlay(isLoading, text: "Loading...")
        }
    }
    
    private var toastOverlay: some View {
        VStack {
            if vm.showSaveSuccessAlert {
                ToastView(message: vm.saveSuccessMessage)
                    .padding(.bottom, 20)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { vm.showSaveSuccessAlert = false }
                        }
                    }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }

    private func validateLogin() {

        if userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            vm.saveSuccessMessage = "Please Enter User Name"
            vm.showSaveSuccessAlert = true
            return
        }

        if password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            vm.saveSuccessMessage = "Please enter password"
            vm.showSaveSuccessAlert = true
            return
        }
        
        Task {
            startLoading()
            await vm.SignIn(username: userName, password: password)
            stopLoading()
            
//            if vm.loginData?.success == true {
//                navigateToSettings = true
//            }
        }
    }
    
    private func startLoading() {
        isLoading = true
    }
    
    private func stopLoading() {
        isLoading = false
    }
}

struct LoginContent: View {

    let geo: GeometryProxy

    @Binding var userName: String
    @Binding var password: String

    let loginAction: () -> Void

    private var isLandscape: Bool {
        geo.size.width > geo.size.height
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            ZStack(alignment: .leading) {

                Image("Group 14")
                    .resizable()
                    .ignoresSafeArea(edges: .top)
                    .frame(maxWidth: .infinity)
                    .frame(height: geo.size.height * 0.30)

                VStack {

                    Spacer()

                    VStack(alignment: .leading, spacing: 6) {

                        HStack(spacing: 4) {

                            Text("Welcome")
                                .font(.poppinsBold(20))
                                .foregroundColor(.white)

                            ImageV(
                                name: "hand",
                                type: .assetName
                            )
                        }

                        Text("to Sales Jump!")
                            .font(.poppinsBold(24))
                            .foregroundColor(.white)
                    }
                    .padding(
                        .top,
                        UIDevice.current.userInterfaceIdiom == .pad
                        ? geo.size.height * 0.04
                        : geo.size.height * 0.01
                    )
                    .padding(
                        .leading,
                        UIDevice.current.userInterfaceIdiom == .pad
                        ? 40
                        : 30
                    )

                    Spacer()
                }
                .frame(height: geo.size.height * 0.30)
            }

            LoginAccountView(
                userName: $userName,
                password: $password,
                loginAction: loginAction
            )
            .padding(.top, isLandscape ? -20 : -70)
            .padding(
                UIDevice.current.userInterfaceIdiom == .pad
                ? 16
                : 10
            )

            Text("Version \(appVersion ?? "0.1")")
                .font(.poppinsMedium(14))
                .foregroundColor(.appBlack)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(8)

            Spacer(minLength: 20)

            HStack {

                Spacer()

                Image("salesJump")

                Spacer()
            }
            .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: geo.size.height)
    }
}

struct LoginAccountView: View {
    //@State private var user = "User Name"
    @Binding var userName: String
    @Binding var password: String

    let loginAction: () -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 15) {

            Text("Login to your Account")
                .font(.poppinsMedium(16))
                .foregroundColor(.appBlack)
                .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 5) {
               // Login_TxtfieldName(titleName: $user)
                
                Text("User name")
                    .font(.poppinsRegular(13))

                TextField("Enter User Name", text: $userName)
                    .font(.poppinsRegular(13))
                    .padding(
                        UIDevice.current.userInterfaceIdiom == .pad
                        ? 16
                        : 8
                    )
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
            }

            PasswordTextField(password: $password)

            CustomBtn(
                title: "Login",
                height: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40,
                cornerRadius: 5,
                fontsize: 16,
                backgroundColor: .appPrimary,
                fontWeight: .semibold
            ) {
                UIApplication.shared.dismissKeyboard()
                loginAction()
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .cardStyle(cornerRadius: 5)
    }
}

struct PasswordTextField: View {

    @State private var titleName = "Password"

    @Binding var password: String

    @State private var isPasswordVisible = false

    var body: some View {

        VStack(alignment: .leading, spacing: 5) {

            Login_TxtfieldName(titleName: $titleName)

            HStack {

                if isPasswordVisible {

                    TextField("Enter Password", text: $password)
                        .font(.poppinsRegular(13))

                } else {

                    SecureField("Enter Password", text: $password)
                        .font(.poppinsRegular(13))
                }

                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding(
                UIDevice.current.userInterfaceIdiom == .pad
                ? 16
                : 8
            )
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(ToastManager())
}
