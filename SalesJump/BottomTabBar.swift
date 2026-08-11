//
//  BottomTabBar.swift
//  SalesJump
//
//  Created by Saneforce on 11/08/26.
//

import SwiftUI
struct BottomTabBar: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            
            Group {
                switch selectedTab {
                case 0:
                    DashboardView()
                case 1:
                   Text("Reports")
                case 2:
                    Text("Inbox")
                case 3:
                    MenuView()
                default:
                    DashboardView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            HStack {
                Spacer()
                bottomTab(image: "Vector",title: "Home",tag: 0)
                Spacer()
                bottomTab(image: "Reports",title: "Reports",tag: 1)
                Spacer()
                bottomTab(image: "Inbox",title: "Inbox",tag: 2)
                Spacer()
                bottomTab(image: "Menu",title: "Menu",tag: 3)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .overlay(
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 0.5),
                alignment: .top
            )
        }
    }
    
    
    @ViewBuilder
    private func bottomTab(image: String,title: String,tag: Int) -> some View {
        
        let isSelected = selectedTab == tag
        
        VStack(spacing: 0) {
            
            Rectangle()
                .frame(width: 48, height: 4)
                .foregroundStyle(
                    isSelected
                    ? .appPrimary
                    : .clear
                )
                .clipShape(
                    RoundedCorner(
                        radius: 2,
                        corners: [.bottomLeft, .bottomRight]
                    )
                )
                .scaleEffect(x: isSelected ? 1 : 0.5, y: 1)
                .animation(
                    .spring(response: 0.3, dampingFraction: 0.7),
                    value: isSelected
                )
            
            Spacer()
            
            Image(image)
                .resizable()
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(
                    selectedTab == tag
                    ? .appPrimary
                    : .primary
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(
                    .spring(response: 0.3, dampingFraction: 0.7),
                    value: isSelected
                )
            
            Text(title)
                .font(.poppinsMedium(14))
                .opacity(isSelected ? 1 : 0.7)
                .padding(.top,8)
                .foregroundStyle(
                    selectedTab == tag
                    ? .appPrimary
                    : .primary
                )
                .animation(
                    .easeInOut(duration: 0.2),
                    value: isSelected
                )
            
            Spacer()
        }
        .frame(height: 72)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selectedTab = tag
            }
        }
    }
}
