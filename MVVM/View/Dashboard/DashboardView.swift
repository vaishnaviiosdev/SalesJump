//
//  DashboardView.swift
//  SalesJump
//
//  Created by San eforce on 27/07/26.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        ZStack {
                    Color.blue.ignoresSafeArea()

                    Text("www.salesjump.in")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.red)
                }
    }
}

#Preview {
    DashboardView()
}
