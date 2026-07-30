//
//  common.swift
//  SalesJump
//
//  Created by San eforce on 27/07/26.
//

import SwiftUI
import Foundation

enum ImageType {
    case systemName
    case assetName
}

struct ImageV: View {
    var name: String
    var type: ImageType
    var width: CGFloat = 24
    var height: CGFloat = 24
    var color: Color = .gray
    var fontWeight: Font.Weight = .regular
    
    var body: some View {
        switch type {
        case .systemName:
            Image(systemName: name)
                .resizable()
                .scaledToFit()
                .foregroundColor(color)
                .font(.system(size: max(width, height), weight: fontWeight))
                .frame(width: width, height: height)
                
        case .assetName:
            Image(name)
                .resizable()
                .scaledToFit()
                .foregroundColor(color)
                .frame(width: width, height: height)
        }
    }
}

struct CustomBtn: View {
    var title: String
    var height: CGFloat = 50
    var width: CGFloat = .infinity
    var cornerRadius: CGFloat = 9
    var fontsize: CGFloat = 17
    var backgroundColor: Color = Color.white
    var fontWeight: Font.Weight = .medium
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: width, minHeight: height)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .font(.poppinsMedium(fontsize))
                .foregroundColor(.white)
                .fontWeight(fontWeight)
        }
    }
}

struct HomeBarWithBack: View {
    var frameSize: CGFloat = 40
    var backgroundColor: Color = .appPrimary
    var fontSize: CGFloat = 16
    var fontWeight: Font.Weight = .bold
    var foregroundClr: Color = .white
    @State var showBackButton: Bool
    @State var showTitleText: Bool
    @State var titleText: String
    @State var showHomeButton: Bool = true
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            if showBackButton == true {
                dismissBackButton(action: {
                    dismiss()
                },
                foregroundColour: .black, fontWeight: .medium)
            }
            
            Spacer()
            
            if showTitleText ==  true {
                Text (titleText)
                    .font(.poppinsRegular(16))
                    .foregroundColor(foregroundClr)
                    .fontWeight(fontWeight)
                    //.frame(maxWidth: .infinity, alignment: .center)
                    //.regularTextStyle(size: fontSize, foreground: foregroundClr, fontWeight: fontWeight)
                    //.padding(.leading, 10)
            }
            
            Spacer()
            
            if showHomeButton == true {
                NavigationLink(destination: DashboardView()) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                }
            }
        }
        .frame(height: frameSize)
        .background(backgroundColor)
    }
}

struct dismissBackButton: View {
    var action: () -> Void
    var foregroundColour: Color = .white
    var width: CGFloat = 10
    var Height: CGFloat = 17
    var leading: CGFloat = 16
    var fontWeight: Font.Weight = .heavy

    var body: some View {
        Button(action: action) {
            ImageV(name: "chevron.backward", type: .systemName, width: width, height: Height, color: foregroundColour, fontWeight: fontWeight)
                .padding(.trailing, 5)
                .padding(.leading, leading)
        }
    }
}
