//
//  DashboardView.swift
//  SalesJump
//
//  Created by San eforce on 07/08/26.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var vm = AuthenticationViewModel()
    @StateObject private var dashboardVM = DashboardViewModel()
    @State private var showSettings = false
    @State private var goToMyDayPlan:Bool = false
    
    var body: some View {
        NavigationStack {
        GeometryReader { geo in
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        let imageSize = min(geo.size.width * 0.13, 100)
                        
                        if let image = vm.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: imageSize, height: imageSize)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(.black, lineWidth: 1)
                                )
                        }
                        else {
                            Image("Profile Picture_1")
                                .resizable()
                                .scaledToFill()
                                .frame(width: imageSize, height: imageSize)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(.black, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(SessionManager.shared.sfName)
                                .font(.poppinsMedium(16))
                            
                            Text(SessionManager.shared.Desig_Code)
                                .font(.poppinsMedium(16))
                                .foregroundColor(.appTextGrey)
                        }
                        
                        Spacer()
                        
                        Button {
                            showSettings = true
                        } label: {
                            ImageV(
                                name: "gearshape",
                                type: .systemName,
                                color: .black
                            )
                        }
                    }
                    
                    CustomBtn(
                        title: "Check-IN",
                        height: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40,
                        cornerRadius: 5,
                        fontsize: 13,
                        backgroundColor: .appPrimary,
                        fontWeight: .heavy
                    ) {
                        goToMyDayPlan =  true
                        UIApplication.shared.dismissKeyboard()
                    }
                    .navigationDestination(isPresented: $goToMyDayPlan) {
                                    MyDayPlanView()
                                }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 10) {
                            
                            //                            Text("Quick Actions")
                            //                                .font(.poppinsSemiBold(16))
                            //                                .foregroundColor(.black)
                            //
                            //                            Spacer()
                            //                                .frame(height: 5)
                            //
                            //                            HStack(spacing: 8) {
                            //                                HomeButtons(
                            //                                    imageName: "Secondary Order",
                            //                                    title: "Retailer Order"
                            //                                )
                            //
                            //                                HomeButtons(
                            //                                    imageName: "Primary Order",
                            //                                    title: "Primary Order"
                            //                                )
                            //                            }
                            //
                            //                            TodayActivityView(vm: dashboardVM)
                            //
                            //                            buttonView()
                            
                            if let mtdData = dashboardVM.MTD?.data?.first {
                                MTDView(data: mtdData)
                            }
                            
                            //                            RecentActivityView(
                            //                                activities: dashboardVM.recentActivity?.data ?? []
                            //                            )
                        }
                        .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal)
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
            .task {
                await vm.fetchProfileImage(
                    fileName: SessionManager.shared.ProfilePicString
                )
                
                await dashboardVM.getSecondarySales(Type: 1)
                await dashboardVM.getSecondarySales(Type: 2)
                await dashboardVM.getMTD()
                await dashboardVM.getRecentActivity()
            }
        }
    }
    }
}

struct RecentActivityView: View {
    
    let activities: [RecentActivityData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Recent Activity")
                .font(.poppinsSemiBold(16))
                .foregroundColor(.appBlack)
            
            RecentActivityList(activities: activities)
        }
    }
}

struct RecentActivityList: View {
    
    let activities: [RecentActivityData]
    
    var body: some View {
        VStack(spacing: 0) {
            
            ForEach(activities) { activity in
                
                HStack {
                    
                    ImageV(name: "OrderTaken", type: .assetName)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 1)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text(activity.Title ?? "--")
                            .font(.poppinsSemiBold(13))
                            .foregroundColor(.appBlack)
                        
                        Text(activity.Date ?? "--")
                            .font(.poppinsMedium(13))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text(String(format: "%.2f", Double(activity.Amount ?? 0)))
                        .font(.poppinsSemiBold(13))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                
                Divider()
                    .frame(height: 0.5)
                    .background(Color.secondary)
            }
        }
    }
}

struct MTDView: View {
    
    let data: MTDData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("MTD Analysis")
                .font(.poppinsSemiBold(16))
            
            VStack(spacing: 0) {
                
                TargetView(data: data)
                
                MTDDetailsView(data: data)
            }
            .cardStyle(cornerRadius: 8)
        }
    }
}

struct TargetView: View {
    
    let data: MTDData
    
    private var target: Double {
        Double(data.TargetValue ?? "0") ?? 0.0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                
                Text("Target")
                    .font(.poppinsMedium(14))
                
                Spacer()
                
                Text((target > 0 ? data.TargetValue : "-") ?? "-")
                    .font(.poppinsMedium(14))
            }
            .padding(8)
            
            SalesProgressView(
                progress: target > 0 ? 100 : 0
            )
            
            HStack {
                
                Text("-")
                    .font(.poppinsMedium(14))
                    .foregroundColor(.appBlack)
                
                Spacer()
                
                Text(data.TotalOrderValue ?? "-")
                    .font(.poppinsMedium(14))
                    .foregroundColor(.gray)
            }
            .padding(8)
        }
    }
}

struct MTDDetailsView: View {
    
    let data: MTDData
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 12) {
                
                Text("Coverage")
                    .font(.poppinsMedium(14))
                
                CircularProgressView(
                    current: data.TotalCalls ?? 0,
                    total: data.Coverage ?? 0,
                    backgroundColour: .appGreen
                )
            }
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 2, height: 60)
            
            VStack(spacing: 12) {
                
                Text("Productive")
                    .font(.poppinsMedium(14))
                
                CircularProgressView(
                    current: data.ProductiveCalls ?? 0,
                    total: data.TotalCalls ?? 0,
                    backgroundColour: .appRed
                )
            }
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 2, height: 90)
            
            VStack(spacing: 10) {
                
                ImageV(
                    name: "clock",
                    type: .systemName,
                    color: .appPrimary
                )
                
                Text("Time Spent")
                    .font(.poppinsMedium(14))
                    .foregroundColor(.appBlack)
                
                Text("00:00:00")
                    .font(.poppinsMedium(14))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
    }
}

struct CircularProgressView: View {
    
    let current: Int
    let total: Int
    var backgroundColour: Color = Color.teal
    
    private var progress: CGFloat {
        guard total > 0 else { return 0 }
        return CGFloat(current) / CGFloat(total)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.15),
                    lineWidth: 18
                )
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    backgroundColour,
                    style: StrokeStyle(
                        lineWidth: 18,
                        lineCap: .butt
                    )
                )
                .rotationEffect(.degrees(-90))
            
            Text("\(current)/\(total)")
                .font(.poppinsMedium(14))
                .foregroundColor(.appBlack)
        }
        .frame(width: 80, height: 100)
    }
}

struct buttonView: View {
    var body: some View {
        HStack(spacing: 8) {
            CustomBtn(
                title: "Switch Route",
                height: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40,
                cornerRadius: 5,
                fontsize: 13,
                backgroundColor: .appPrimary,
                fontWeight: .bold
            ) {
                UIApplication.shared.dismissKeyboard()
                
            }
            
            CustomBtn(
                title: "Check-Out",
                height: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40,
                cornerRadius: 5,
                fontsize: 13,
                backgroundColor: Color.white,
                foregroundColor: .appPrimary,
                borderColor: .appPrimary,
                borderWidth: 2,
                fontWeight: .semibold,
            ) {
                UIApplication.shared.dismissKeyboard()
            }
        }
    }
}

struct TodayActivityView: View {
    @ObservedObject var vm: DashboardViewModel
    @State private var isSecondaryExpanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Today's Activity")
                .font(.poppinsSemiBold(16))
            
            secondarySales(vm: vm)
            
            primarySales(vm: vm)
        }
    }
}

struct secondarySales: View {
    
    @ObservedObject var vm: DashboardViewModel

    @State private var isSecondaryExpanded = false
    
    var body: some View {
        
        let item = vm.secondarySales?.data?.first

        let visited = item?.Visited_Count ?? 0
        let pending = item?.Pending_Count ?? 0
        let total = visited + pending

        let productive =
        total > 0
        ? Int((Double(visited) / Double(total)) * 100)
        : 0
        
        VStack(spacing: 0) {

            HStack {

                Text("Secondary Sales")
                    .font(.poppinsMedium(14))

                Circle()
                    .fill(Color.black)
                    .frame(width: 25,height: 25)
                    .overlay {

                        Text("\(vm.secondarySales?.data?.count ?? 0)")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }

                Spacer()

                Button {

                    isSecondaryExpanded.toggle()

                } label: {

                    ImageV(
                        name: isSecondaryExpanded ? "chevron.up" : "chevron.down",
                        type: .systemName,
                        width: 12,
                        height: 12,
                        color: .black
                    )
                }
            }
            .padding(8)

            if isSecondaryExpanded {

                Divider()
                    .frame(height: 0.5)
                    .background(Color.gray)

                HStack {

                    Text(item?.Route_Name ?? "-")
                        .font(.poppinsMedium(14))

                    Spacer()

                    Text(String(format: "%.2f", item?.Total_Order_Value ?? 0))
                        .font(.poppinsMedium(14))
                }
                .padding(8)

                SalesProgressView(
                    progress: CGFloat(Double(productive) / 100.0)
                )

                HStack {

                    Text("Productive: \(productive)%")
                        .font(.poppinsMedium(14))
                        .foregroundColor(.appPrimary)

                    Spacer()

                    Text("Coverage : \(visited)/\(pending)")
                        .font(.poppinsMedium(14))
                        .foregroundColor(.gray)

                    ImageV(
                        name: "chevron.right",
                        type: .systemName,
                        width: 15,
                        height: 15,
                        color: .gray
                    )
                }
                .padding(8)
            }
        }
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray)
        )
        .cornerRadius(5)

    }
}

struct primarySales: View {
    
    @ObservedObject var vm: DashboardViewModel

    @State private var isSecondaryExpanded = false
    
    var body: some View {
        
        let item = vm.primarySales?.data?.first
        
        let visited = item?.VisitedCount ?? 0
        let pending = item?.PendingCount ?? 0
        let total = visited + pending

        let productive =
        total > 0
        ? Int((Double(visited) / Double(total)) * 100)
        : 0
        
        VStack(spacing: 0) {

            HStack {

                Text("Primary Sales")
                    .font(.poppinsMedium(14))

                Circle()
                    .fill(Color.black)
                    .frame(width: 25,height: 25)
                    .overlay {

                        Text("\(vm.secondarySales?.data?.count ?? 0)")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }

                Spacer()

                Button {

                    isSecondaryExpanded.toggle()

                } label: {

                    ImageV(
                        name: isSecondaryExpanded ? "chevron.up" : "chevron.down",
                        type: .systemName,
                        width: 12,
                        height: 12,
                        color: .black
                    )
                }
            }
            .padding(8)

            if isSecondaryExpanded {

                Divider()
                    .frame(height: 0.5)
                    .background(Color.gray)

                HStack {

                    Text("Distributor")
                        .font(.poppinsMedium(14))

                    Spacer()

                    Text(String(format: "%.2f", item?.TotalOrderValue ?? 0))
                        .font(.poppinsMedium(14))
                }
                .padding(8)

                SalesProgressView(
                    progress: CGFloat(Double(productive) / 100.0)
                )

                HStack {

                    Text("Productive: \(productive)%")
                        .font(.poppinsMedium(14))
                        .foregroundColor(.appPrimary)

                    Spacer()

                    Text("Coverage : \(visited)/\(total)")
                        .font(.poppinsMedium(14))
                        .foregroundColor(.gray)

                    ImageV(
                        name: "chevron.right",
                        type: .systemName,
                        width: 15,
                        height: 15,
                        color: .gray
                    )
                }
                .padding(8)
            }
        }
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray)
        )
        .cornerRadius(5)

    }
}

struct SalesProgressView: View {

    var progress: CGFloat

    var body: some View {

        GeometryReader { geo in

            ZStack(alignment: .leading) {

                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 4)

                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.appGreen)
                    .frame(
                        width: geo.size.width * progress,
                        height: 4
                    )
            }
            .padding(.horizontal,8)
        }
        .frame(height:6)
    }
}

struct HomeButtons: View {

    let imageName: String
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            ImageV(name: imageName, type: .assetName)

            Text(title)
                .font(.poppinsMedium(14))
                .foregroundColor(.black)

            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(Color.appPrimaryLight)
        .cornerRadius(5)
    }
}

#Preview {
    DashboardView()
}
