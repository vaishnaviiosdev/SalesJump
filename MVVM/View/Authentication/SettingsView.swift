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
                        
                        Text("malli")
                            .font(.poppinsMedium(16))
                            .offset(y: -30)
                        
                        Text("SE")
                            .font(.poppinsMedium(16))
                            .foregroundColor(Color.appTextGrey)
                            .offset(y: -20)
                    }
                    
                    Spacer()
                }
            }
            .onAppear {

                if let image = vm.loadProfileImage() {
                    profileImage = image
                }
                else {
                    Task {
                        await vm.fetchProfileImage(fileName: "profile.jpg")
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
        }
    }
}

#Preview {
    SettingsView()
}
