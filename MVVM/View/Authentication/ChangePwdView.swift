//
//  ChangePwdView.swift
//  SalesJump
//
//  Created by San eforce on 04/08/26.
//

import SwiftUI

struct ChangePwdView: View {
    @EnvironmentObject var toastManager: ToastManager
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = AuthenticationViewModel()
    @State private var pwdTitle = "Password"
    @State private var CnfpwdTitle = "Confirm Password"
    @State private var pwdPlaceholderTitle = "Enter the Password"
    @State private var CnfpwdPlaceholderTitle = "Re-enter Password"
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 15) {
                HomeBarWithBack(
                    frameSize: 50,
                    backgroundColor: .white,
                    fontSize: 18,
                    fontWeight: .semibold,
                    foregroundClr: .black,
                    showBackButton: true,
                    showTitleText: true,
                    titleText: "Change Password",
                    showHomeButton: false)
                .padding(.top, 1)
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                .shadow(color: .gray.opacity(0.15), radius: 3, x: 0, y: -2)
                
                Text("Create new password")
                    .font(.poppinsMedium(16))
                    .foregroundColor(.appBlack)
                    .padding(.horizontal, 8)
                
                Text("Your new password must be different from previous used passwords.")
                    .font(.poppinsMedium(14))
                    .foregroundColor(.appTextGrey)
                    .padding(.horizontal, 8)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Atleast 8 characters, with upper case, lowercase letters, special character and numbers")
                    Text("eg: Password@123")
                        
                }
                .font(.poppinsMedium(14))
                .foregroundColor(.appTextGrey)
                .padding(.horizontal, 8)
                
                Spacer().frame(height: 10)
                
                PwdTextField(titleName: $pwdTitle, password: $password, placeholderTitle: $pwdPlaceholderTitle)
                    .padding(.horizontal, 8)
                
                PwdTextField(titleName: $CnfpwdTitle, password: $confirmPassword, placeholderTitle: $CnfpwdPlaceholderTitle)
                    .padding(.horizontal, 8)
                
                Spacer().frame(height: 5)
                
                CustomBtn(
                    title: "Reset Password",
                    height: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40,
                    cornerRadius: 5,
                    fontsize: 16,
                    backgroundColor: .appPrimary,
                    fontWeight: .semibold
                ) {
                    UIApplication.shared.dismissKeyboard()
                    Task {
                        if let errorMsg = validatePassword() {
                            toastManager.showToast(errorMsg)
                        }
                        else {
                            startLoading()
                            await vm.changePassword(pwd: password)
                            stopLoading()
                        }
                    }
                }
                .padding(.horizontal, 8)
                
                Spacer()
            }
            toastOverlay
        }
        .toast(toastManager)
        .loadingOverlay(isLoading, text: "Loading...")
        .navigationBarBackButtonHidden(true)
    }
    
    private func startLoading() {
        isLoading = true
    }
    
    private func stopLoading() {
        isLoading = false
    }
    
    private var toastOverlay: some View {
        VStack {
            if vm.showSaveSuccessAlert {
                ToastView(message: vm.saveSuccessMessage)
                    .padding(.bottom, 20)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                vm.showSaveSuccessAlert = false
                            }
                            
                            dismiss()
                        }
                    }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    
    private func validatePassword() -> String? {
        if password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Enter the password"
        }
        else if confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Enter the confirm password"
        }
        else if password != confirmPassword {
            return "Password does not meet the requirements"
        }
        return nil
    }
}

struct PwdTextField: View {
    @Binding var titleName: String
    @Binding var password: String
    @Binding var placeholderTitle: String
    @State private var isPasswordVisible = false

    var body: some View {

        VStack(alignment: .leading, spacing: 15) {

            TxtfieldName(titleName: $titleName)

            HStack {
                if isPasswordVisible {
                    TextField(placeholderTitle, text: $password)
                        .font(.poppinsRegular(13))
                }
                else {
                    SecureField(placeholderTitle, text: $password)
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

struct TxtfieldName: View {
    @Binding var titleName: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(titleName)
                .font(.poppinsSemiBold(12))
                .foregroundColor(.appBlack)
        }
    }
}

#Preview {
    ChangePwdView()
}
