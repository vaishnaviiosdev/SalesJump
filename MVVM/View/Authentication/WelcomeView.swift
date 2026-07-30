//
//  SalesJumpApp.swift
//  SalesJump
//
//  Created by San eforce on 27/07/26.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        GeometryReader { geo in

            let isLandscape = geo.size.width > geo.size.height

            let imageSize = isLandscape
                ? geo.size.height * 0.55
                : geo.size.width * 0.50

            ZStack {
                Color.appPrimary
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    ImageV(
                        name: "Color_SVG 1",
                        type: .assetName,
                        width: imageSize,
                        height: imageSize
                    )

                    Spacer()

                    Text(verbatim: "www.salesjump.in")
                        .font(.poppinsMedium(14))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
