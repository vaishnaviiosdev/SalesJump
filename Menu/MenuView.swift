//
//  MenuView.swift
//  SalesJump
//
//  Created by Saneforce on 11/08/26.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        NavigationStack {
        ZStack{
            VStack{
                
                Spacer()
                
                
                HStack{
                    Spacer()
                    
                    Text("Submitted Calls")
                        .font(.poppinsMedium(14))
                        .frame(
                            maxWidth: horizontalSizeClass == .regular ? .infinity : nil
                        )
                        .frame(height: 40)
                        .padding(.horizontal,14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                    Spacer()
                    NavigationLink {
                        MasterSyncView()
                    } label: {

                    Text("Master Sync")
                        .font(.poppinsMedium(14))
                        .frame(
                            maxWidth: horizontalSizeClass == .regular ? .infinity : nil
                        )
                        .frame(height: 40)
                        .padding(.horizontal,14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                    }
                    .buttonStyle(.plain)
                       
                    Spacer()
                    Text("Outbox")
                        .font(.poppinsMedium(14))
                        .frame(
                            maxWidth: horizontalSizeClass == .regular ? .infinity : nil
                        )
                        .frame(height: 40)
                        .padding(.horizontal,14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                    Spacer()
                    
                }.frame(maxWidth: .infinity)
                    .frame(height: 67)
                    .overlay(
                        TopRoundedRectangle(radius: 12)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                    )
                
                
            }
            
        }
    }
    }
}

struct TopRoundedRectangle: Shape {
    var radius: CGFloat = 12

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: radius))

        path.addQuadCurve(
            to: CGPoint(x: radius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )

        path.addLine(to: CGPoint(x: rect.width - radius, y: 0))

        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: radius),
            control: CGPoint(x: rect.width, y: 0)
        )

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()

        return path
    }
}
