//
//  TabBarView.swift
//  SalesJump
//
//  Created by San eforce on 11/08/26.
//

import SwiftUI

struct TabbarView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Group {
                switch selectedTab {
                    
                case 0:
                    DashboardView()
                    
                case 1:
                    demoView()
                    
                case 2:
                    demoView()
                    
                case 3:
                    MenuView()
                    
                default:
                    DashboardView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            customTabBar
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabButton(
                title: "Home",
                imageName: "Home",
                index: 0
            )

            tabButton(
                title: "Reports",
                imageName: "Reports",
                index: 1
            )

            tabButton(
                title: "Inbox",
                imageName: "Vector",
                index: 2
            )

            tabButton(
                title: "Menu",
                imageName: "Menu",
                index: 3
            )
        }
        .frame(height: 75)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(height: 1),
            alignment: .top
        )
    }
    
    private func tabButton(
        title: String,
        imageName: String,
        index: Int
    ) -> some View {
        
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        selectedTab == index
                        ? Color.appPrimary
                        : Color.clear
                    )
                    .frame(width: 60, height: 5)
                
                ImageV(
                    name: imageName,
                    type: .assetName,
                    color: selectedTab == index
                        ? .appPrimary
                        : .appBlack
                )
                .frame(width: 27, height: 27)
                
                Text(title)
                    .font(.poppinsMedium(15))
                    .foregroundColor(
                        selectedTab == index
                        ? .appPrimary
                        : .appBlack
                    )
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TabbarView()
}
