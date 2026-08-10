//
//  SettingsView.swift
//  SalesJump
//
//  Created by San eforce on 29/07/26.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @StateObject private var vm = AuthenticationViewModel()
    @State private var profileImage: UIImage?
    @AppStorage("Sf_Name") private var sfName = ""
    @AppStorage("Desig_Code") private var desigCode = ""
    @State private var showLogoutAlert = false
    @StateObject private var permissionManager = PermissionManager()
    @EnvironmentObject var router: AppRouter
    @State private var isLoading = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 10) {
                    HomeBarWithBack(
                        frameSize: 50,
                        backgroundColor: .white,
                        fontSize: 18,
                        fontWeight: .semibold,
                        foregroundClr: .black,
                        showBackButton: true,
                        showTitleText: true,
                        titleText: "Settings",
                        showHomeButton: false)
                    .padding(.top, 1)
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                    .shadow(color: .gray.opacity(0.15), radius: 3, x: 0, y: -2)
                    
                    let imageSize = min(geo.size.width * 0.22, 120)
                    ScrollView(showsIndicators: false) {
                        VStack {
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                if let image = profileImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageSize, height: imageSize)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle().stroke(.black, lineWidth: 1)
                                        )
                                }
                                else {
                                    Image("profile_pic")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageSize, height: imageSize)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle().stroke(.black, lineWidth: 1)
                                        )
                                }
                            }
                            
                            ImageV(name: "Edit_pen", type: .assetName)
                                .offset(x: 30, y: -30)
                            
                            Text(sfName)
                                .font(.poppinsMedium(16))
                                .offset(y: -30)
                            
                            Text(desigCode)
                                .font(.poppinsMedium(16))
                                .foregroundColor(Color.appTextGrey)
                                .offset(y: -20)
                            
                            
                            SettingsListView(showLogoutAlert: $showLogoutAlert)
                                .offset(y: -20)
                                .padding(5)
                            //}
                        }
                    }
                   Spacer()
                }
                
                if showLogoutAlert {
                    LogoutAlertView(
                        onOK: {
                            showLogoutAlert = false
                            startLoading()
                            
                            permissionManager.onLocationReceived = { location in

                                Task {
                                    

                                    await vm.logout(
                                        latitude: "\(location.coordinate.latitude)",
                                        longitude: "\(location.coordinate.longitude)"
                                    )

                                    stopLoading()

                                    if vm.logout?.success == true {

                                        UserDefaults.standard.removeObject(forKey: "User_Login")
                                        UserDefaults.standard.removeObject(forKey: "jwt_Token")
                                        UserDefaults.standard.removeObject(forKey: "Sf_Name")
                                        UserDefaults.standard.removeObject(forKey: "Sf_code")
                                        UserDefaults.standard.removeObject(forKey: "Desig_Code")
                                        UserDefaults.standard.removeObject(forKey: "sender_Id")

                                        router.logout()
                                    }
                                }
                            }

                            permissionManager.requestLocation()
                        },
                        onCancel: {
                            showLogoutAlert = false
                        }
                    )
                }
            }
            .onAppear {
                //permissionManager.requestLocation()
                sfName = UserDefaults.standard.string(forKey: "Sf_Name") ?? ""
                desigCode = UserDefaults.standard.string(forKey: "Desig_Code") ?? ""

                if let image = vm.loadProfileImage() {
                    profileImage = image
                }
                else {
                    Task {
                        await vm.fetchProfileImage(fileName: SessionManager.shared.ProfilePicString)
                    }
                }
            }
            .onReceive(vm.$profileImage) { image in
                profileImage = image
            }
            .onChange(of: selectedItem) { newItem in

                Task {
                    guard let data = try? await newItem?.loadTransferable(type: Data.self),
                          let image = UIImage(data: data) else {
                        return
                    }

                    selectedImage = image

                    await vm.uploadImage(selectedImage: image)
                }
            }
            .alert(
                "Enable GPS",
                isPresented: $permissionManager.showPermissionAlert
            ) {
                Button("Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("GPS is required to get your accurate location. Please enable GPS in settings")
            }
            .loadingOverlay(isLoading, text: "Loading...")
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func startLoading() {
        isLoading = true
    }
    
    private func stopLoading() {
        isLoading = false
    }
}

struct SettingsListView: View {
    
    @Binding var showLogoutAlert: Bool

    let settingsItems: [SettingsItem] = [
        .init(title: "Change Password",
              systemImage: "arrow.right",
              destination: .changePassword),

        .init(title: "Quick Action Setup",
              systemImage: "arrow.right",
              destination: .quickAction),

        .init(title: "Fingerprint Setup",
              systemImage: "arrow.right",
              destination: .fingerprint),

        .init(title: "Language",
              systemImage: "arrow.right",
              destination: .language),

        .init(title: "Logout",
              systemImage: "arrow.right",
              destination: .logout),

        .init(title: "Check for Updates",
              systemImage: "arrow.clockwise",
              destination: .checkUpdates)
    ]

    var body: some View {

        VStack(spacing: 0) {

//            ForEach(settingsItems.indices, id: \.self) { index in
//
//                NavigationLink {
//
//                    destinationView(for: settingsItems[index].destination)
//
//                } label: {
//
//                    HStack {
//                        Text(settingsItems[index].title)
//                            .font(.poppinsMedium(16))
//                            .foregroundColor(.black)
//
//                        Spacer()
//
//                        ImageV(name: settingsItems[index].systemImage,
//                            type: .systemName,
//                            color: .appPrimary)
//                    }
//                    .padding()
//                }
//
//                if index != settingsItems.count - 1 {
//                    Divider()
//                }
//            }
            
            ForEach(settingsItems.indices, id: \.self) { index in

                let item = settingsItems[index]

                if item.destination == .logout {

                    Button {
                        showLogoutAlert = true
                    } label: {

                        HStack {
                            Text(item.title)
                                .font(.poppinsMedium(16))
                                .foregroundColor(.black)

                            Spacer()

                            ImageV(
                                name: item.systemImage,
                                type: .systemName,
                                color: .appPrimary
                            )
                        }
                        .padding()
                    }
                }
                else {

                    NavigationLink {
                        destinationView(for: item.destination)
                    } label: {

                        HStack {
                            Text(item.title)
                                .font(.poppinsMedium(16))
                                .foregroundColor(.black)

                            Spacer()

                            ImageV(
                                name: item.systemImage,
                                type: .systemName,
                                color: .appPrimary
                            )
                        }
                        .padding()
                    }
                }

                if index != settingsItems.count - 1 {
                    Divider()
                }
            }
        }
        .cardStyle(cornerRadius: 5, backgroundColor: .white)
    }

    @ViewBuilder
    private func destinationView(for destination: SettingsDestination) -> some View {

        switch destination {

        case .changePassword:
            ChangePwdView()

        case .quickAction:
            demoView()

        case .fingerprint:
            demoView()

        case .language:
            demoView()

        case .logout:
            demoView()

        case .checkUpdates:
            demoView()
        }
    }
}

struct LogoutAlertView: View {

    let onOK: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                Text("Logout")
                    .font(.poppinsSemiBold(18))
                    .foregroundColor(.black)
                    .padding(.top, 30)

                Text("Would you like to Logout?")
                    .font(.poppinsMedium(13))
                    .foregroundColor(.gray)
                    .padding(.top, 20)

                Divider()
                    .padding(.top, 25)

                HStack(spacing: 15) {

                    Button(action: onOK) {

                        Text("OK")
                            .font(.poppinsSemiBold(16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.appPrimary)
                            .cornerRadius(8)
                    }

                    Button(action: onCancel) {

                        Text("Cancel")
                            .font(.poppinsMedium(16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                    }
                }
                .padding(20)
            }
            .background(Color.white)
            .cornerRadius(25)
            .padding(.horizontal, 30)
            .shadow(radius: 10)
        }
    }
}

enum SettingsDestination: Hashable {
    case changePassword
    case quickAction
    case fingerprint
    case language
    case logout
    case checkUpdates
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
    let destination: SettingsDestination
}

#Preview {
    SettingsView()
}
