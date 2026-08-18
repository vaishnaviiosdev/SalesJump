//
//  LeaveHistoryView.swift
//  SalesJump
//
//  Created by San eforce on 18/08/26.
//

import SwiftUI

enum LeaveStatusFilter: String, CaseIterable {
    case approved = "Approved"
    case rejected = "Rejected"
    case cancelled = "Cancelled"
    case pending = "Pending"
}

struct LeaveHistoryView: View {
    @StateObject private var vm = LeaveViewModel()
    @State private var selectedStatus: LeaveStatusFilter? = nil
    @State private var showSortSheet = false
    @State private var year: Int =
        Calendar.current.component(.year, from: Date())
    @State private var isLoading = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    HomeBar(
                        frameSize: 50,
                        backgroundColor: .white,
                        fontSize: 18,
                        fontWeight: .semibold,
                        foregroundClr: .black,
                        showBackButton: true,
                        showTitleText: true,
                        titleText: "Leave History", showSortSheet: $showSortSheet
                    )
                    .padding(.top, 1)
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                    .shadow(color: .gray.opacity(0.15), radius: 3, x: 0, y: -2)
                    
                    if let selectedStatus {
                        HStack {
                            Text("Sort by")
                                .font(.poppinsMedium(15))
                                .foregroundColor(.appBlack)

                            HStack(spacing: 6) {
                                Button {
                                    self.selectedStatus = nil
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.appPrimary.opacity(0.6))
                                }

                                Text(selectedStatus.rawValue)
                                    .font(.poppinsMedium(15))
                                    .foregroundColor(.appPrimary)

                                Divider()
                                    .frame(height: 14)

                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Circle().fill(Color.appPrimary))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(Color.appPrimary.opacity(0.12))
                            )
                        }
                        .padding(.horizontal, 8)
                    }
                    
                    LeaveHistoryYearView(year: $year)
                        .padding(.horizontal, 8)
                        .onChange(of: year) { newYear in
                            Task {
                                startLoading()
                                await vm.fetchLeaveHistory(SelectedYear: newYear)
                                stopLoading()
                            }
                        }
                    
                    let filteredData = vm.leaveHistory?.data?.filter { item in
                        guard let selectedStatus else {
                            return true
                        }

                        return (item.Leave_status ?? "")
                            .lowercased()
                            .contains(selectedStatus.rawValue.lowercased())
                    } ?? []

                    if filteredData.isEmpty {
                        Spacer()

                        VStack(spacing: 12) {
                            ImageV(
                                name: "folder (1)",
                                type: .assetName,
                                width: 100,
                                height: 100
                            )

                            Text("No data found")
                                .font(.poppinsMedium(15))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)

                        Spacer()
                    }
                    else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 10) {
                                ForEach(filteredData) { item in
                                    LeaveHistoryListView(item: item)
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                    
//                    ScrollView(showsIndicators: false) {
//                        LazyVStack(spacing: 10) {
//
//                            let filteredData = vm.leaveHistory?.data?.filter { item in
//                                guard let selectedStatus else {
//                                    return true
//                                }
//
//                                return (item.Leave_status ?? "")
//                                    .lowercased()
//                                    .contains(selectedStatus.rawValue.lowercased())
//                            } ?? []
//
//                            ForEach(filteredData) { item in
//                                LeaveHistoryListView(item: item)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 5)
                }
            }
        }
        .loadingOverlay(
                    isLoading,
                    text: "Loading..."
                )
        .navigationBarBackButtonHidden(true)
        .task {
            startLoading()
            await vm.fetchLeaveHistory(SelectedYear: year)
            stopLoading()
        }
        .sheet(isPresented: $showSortSheet) {
            SortByStatusSheet(
                selectedStatus: $selectedStatus,
                showSheet: $showSortSheet
            )
            .presentationDetents([.height(300)])
        }
    }
    
    private func startLoading() {
        isLoading = true
    }
    
    private func stopLoading() {
        isLoading = false
    }
}

struct LeaveHistoryListView: View {
    let item: LeaveHistoryData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            StatusBaseCard {
                HStack {
                    Text(item.Leave_Date ?? "---")
                        .font(.poppinsMedium(14))
                        .foregroundColor(.appPrimary)
                    Spacer()
                    
                    let bgColor: Color = {
                        let status = (item.Leave_status ?? "").lowercased()
                        
                        if status.contains("reject") {
                            return .appRed.opacity(0.1)
                        }
                        else if status.contains("approved") {
                            return .appGreen.opacity(0.1)
                        }
                        else if status.contains("pending") {
                            return .brown.opacity(0.1)
                        }
                        else {
                            return .appPrimaryLight
                        }
                    }()
                    
                    let foreGroundColor: Color = {
                        let status = (item.Leave_status ?? "").lowercased()
                        
                        if status.contains("reject") {
                            return .appRed
                        }
                        else if status.contains("approved") {
                            return .appGreen
                        }
                        else if status.contains("pending") {
                            return .brown
                        }
                        else {
                            return .appPrimary
                        }
                    }()

                    Text(item.Leave_status ?? "")
                        .regularTextStyle(size: 12, foreground: foreGroundColor, fontWeight: .bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(bgColor)
                }
                
                Divider().background(.gray)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("No of days")
                                .font(.poppinsMedium(13))
                                .foregroundColor(.appTextGrey)
                            Text("\(Int(item.No_of_Days ?? 0.0))")
                                .font(.poppinsSemiBold(13))
                                .foregroundColor(.appBlack)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("Applied Date")
                                .font(.poppinsMedium(13))
                                .foregroundColor(.appTextGrey)
                            Text(item.Created_Date ?? "")
                                .font(.poppinsSemiBold(13))
                                .foregroundColor(.appBlack)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Leave Type")
                            .font(.poppinsMedium(13))
                            .foregroundColor(.appTextGrey)
                        Text(item.Leave_Type_Name ?? "")
                            .font(.poppinsSemiBold(13))
                            .foregroundColor(.appBlack)
                    }
                }
                
                Divider().background(.gray)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Leave Reason")
                            .font(.poppinsMedium(13))
                            .foregroundColor(.appTextGrey)
                        Text(item.Reason ?? "")
                            .font(.poppinsSemiBold(13))
                            .foregroundColor(.appBlack)
                    }
                    Spacer()
                }
                .padding(.bottom, 5)
            }
        }
    }
}

struct StatusBaseCard<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            content
        }
        .padding(10)
        .cardStyle(cornerRadius: 5)
        .padding(.horizontal, 5)
    }
}

struct LeaveHistoryYearView: View {
    @Binding var year: Int
    @State private var selectedDate: Date? = Date()
    @State private var showPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Financial Year*")
                .font(.poppinsMedium(14))
                .foregroundColor(.appTextGrey)

            Button {
                showPicker = true
            } label: {
                HStack {
                    Text(String(year))
                        .font(.poppinsMedium(15))
                        .foregroundColor(.appBlack)

                    Spacer()
                    
                    ImageV(name: "Calendar", type: .assetName, color: .primary)
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $showPicker) {
            YearPickerSheet(
                selectedDate: $selectedDate,
                showPicker: $showPicker,
                year: $year
            )
            .presentationDetents([.height(320)])
        }
    }
}

struct HomeBar: View {
    var frameSize: CGFloat = 40
    var backgroundColor: Color = .appPrimary
    var fontSize: CGFloat = 16
    var fontWeight: Font.Weight = .bold
    var foregroundClr: Color = .white
    @State var showBackButton: Bool
    @State var showTitleText: Bool
    @State var titleText: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.dismiss) var dismiss
    @Binding var showSortSheet : Bool
    
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
            }
            
            Spacer()
            
            Button {
                showSortSheet = true
            } label: {
                ImageV(name: "Menu 1", type: .assetName, width: 20, height: 20, color: .black)
                    .padding(.trailing, 16)
            }
        }
        .frame(height: frameSize)
        .background(backgroundColor)
    }
}

struct SortByStatusSheet: View {

    @Binding var selectedStatus: LeaveStatusFilter?
    @Binding var showSheet: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header: title + close button
            HStack {
                Text("Sort by status")
                    .font(.poppinsSemiBold(18))
                    .foregroundColor(.appBlack)

                Spacer()

                Button {
                    showSheet = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.appBlack)
                        .padding(8)
                        .background(Circle().fill(Color.gray.opacity(0.15)))
                }
            }
            .padding(12)
            .padding(.horizontal, 8)

            Rectangle()
                .fill(.appTextGrey)
                .frame(height: 0.5)

            // Status options
            ForEach(LeaveStatusFilter.allCases, id: \.self) { status in
                Button {
                    selectedStatus = status
                    showSheet = false
                } label: {
                    HStack {
                        Text(status.rawValue)
                            .font(.poppinsRegular(16))
                            .foregroundColor(.appBlack)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if status != LeaveStatusFilter.allCases.last {
                    Rectangle()
                        .fill(.appTextGrey)
                        .frame(height: 0.5)
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
    }
}

#Preview {
    LeaveHistoryView()
}
