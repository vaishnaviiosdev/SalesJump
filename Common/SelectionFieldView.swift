//
//  SelectionFieldView.swift
//  SalesJump
//
//  Created by Saneforce on 17/08/26.
//

import SwiftUI

struct SelectionFieldView: View {

    let title: String
    let value: String
    var isMandatory: Bool = false
    var action: () -> Void

    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isPad ? 8 : 4) {

            HStack(spacing: 2) {
                Text(title)
                    .font(.poppinsMedium(isPad ? 14 : 12))
                    .foregroundStyle(.appTextGrey)

                if isMandatory {
                    Text("*")
                        .font(.poppinsMedium(isPad ? 14 : 12))
                        .foregroundStyle(.red)
                }
            }
            .padding(.leading, 3)

            HStack {

                Text(value)
                    .font(.poppinsMedium(isPad ? 16 : 14))
                    .foregroundStyle(.primary)
                    .padding(.leading, isPad ? 14 : 10)

                Spacer()

                Image("Down Arrow Outline")
                    .resizable()
                    .frame(
                        width: isPad ? 20 : 16,
                        height: isPad ? 20 : 16
                    )
                    .padding(.trailing, isPad ? 14 : 10)
            }
            .frame(height: isPad ? 56 : 44)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        Color(
                            UIColor(
                                red: 0.85,
                                green: 0.85,
                                blue: 0.85,
                                alpha: 1.00
                            )
                        ),
                        lineWidth: 1
                    )
            )
            .contentShape(Rectangle())
            .onTapGesture {
                action()
            }
        }
    }
}
