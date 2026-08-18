//
//  LeaveFormView.swift
//  SalesJump
//
//  Created by San eforce on 18/08/26.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct LeaveFormView: View {
    @State private var selectedLeaveType: String?
    @StateObject private var vm = MenuViewModel()
    @StateObject private var leaveVM = LeaveViewModel()
    @EnvironmentObject var toastManager: ToastManager
    @State private var FromDate: Date? = nil
    @State private var reasonText = ""
    @State private var selectedDayType = "Full day"
    @State private var selectedHalf: String? = nil
    @State private var selectedLeaveTypeID: String?
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var fileName: String?
    @StateObject private var authenVM = AuthenticationViewModel()
    @State private var uploadedImageURL: String?
    @State private var isLoading = false
    
    var body: some View {

        GeometryReader { geo in

            ZStack {

                Color.white
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 10) {

                    HomeBarWithBack(
                        frameSize: 50,
                        backgroundColor: .white,
                        fontSize: 18,
                        fontWeight: .semibold,
                        foregroundClr: .black,
                        showBackButton: true,
                        showTitleText: true,
                        titleText: "Leave",
                        showHomeButton: false
                    )
                    .padding(.top, 1)
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                    .shadow(color: .gray.opacity(0.15), radius: 3, x: 0, y: -2)

                    ScrollView(
                        .vertical,
                        showsIndicators: false
                    ) {
                        LeaveTypeView(vm: vm, selectedLeaveType: $selectedLeaveType, selectedLeaveTypeID: $selectedLeaveTypeID)
                            .padding(.horizontal, 16)
                        
                        LeaveDateView(
                                FromDate: $FromDate,
                                selectedDayType: $selectedDayType,
                                selectedHalf: $selectedHalf
                            )
                        .padding(.horizontal, 16)
                        
                        Spacer().frame(height: 10)
                        
                        LeaveReasonView(reasonText: $reasonText)
                            .padding(.horizontal, 16)
                        
                        Attachment(
                            vm: authenVM, selectedItem: $selectedItem,
                            selectedImage: $selectedImage,
                            fileName: $fileName
                        )
                        .padding(.horizontal, 16)
                    }

                    Spacer()
                    
                    CustomBtn(
                        title: "Submit",
                        height: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40,
                        cornerRadius: 5,
                        fontsize: 13,
                        backgroundColor: .appPrimary,
                        fontWeight: .heavy
                    ) {
                        UIApplication.shared.dismissKeyboard()
                        Task {
                            if let errorMsg = validateLeave() {
                                toastManager.showToast(errorMsg)
                                return
                            }
                                    
                            guard let date = FromDate else {
                                return
                            }
                            
                            guard let leaveTypeID = selectedLeaveTypeID else {
                                return
                            }
                            
                            let fromDateString = apiDateString(from: date)
                            
                            let isHalfDay = selectedDayType == "Half day"
                            
                            let halfDayValue = isHalfDay
                                ? (selectedHalf ?? "")
                                : ""
                            
                            let noOfDays: Double = isHalfDay
                                ? 0.5
                            : 1.0
                            
                            await leaveVM.leaveSubmit(
                                fromDate: fromDateString,
                                toDate: fromDateString,
                                halfDayFlag: isHalfDay,
                                halfDay: halfDayValue,
                                leaveType: leaveTypeID,
                                noofDays: noOfDays,
                                reason: reasonText
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
            }
            .task {
                await vm.fetchLeaveType()
            }
            .toast(toastManager)
            .loadingOverlay(
                        isLoading,
                        text: "Loading..."
                    )
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func apiDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func validateLeave() -> String? {
        if selectedLeaveType?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty ?? true {
            
            return "Please Select Leave Type"
        }
        
        if FromDate == nil {
            return "Select Date"
        }
        
        if reasonText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty {
            
            return "Enter reason for Leave"
        }
        
        return nil
    }
}

extension LeaveFormView {
    private func startLoading() {
        isLoading = true
    }
    
    private func stopLoading() {
        isLoading = false
    }
}

struct LeaveTypeView: View {
    
    @State private var leaveType = "Leave Type"
    
    @ObservedObject var vm: MenuViewModel
    
    @Binding var selectedLeaveType: String?
    @Binding var selectedLeaveTypeID: String?
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: 15
        ) {
            
            Login_TxtfieldName(
                titleName: $leaveType,
                foreGroundColour: .appBlack,
                fontSize: 14
            )
            .padding(.horizontal, 16)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ],
                spacing: 10
            ) {
                
                ForEach(vm.leaveTypes, id: \.id) { leaveType in
                    
                    Button {
                        
                        selectedLeaveType = leaveType.Leave_Name
                        selectedLeaveTypeID = leaveType.LeaveCode
                        
                    } label: {
                        
                        Text(leaveType.Leave_Name ?? "")
                            .font(.poppinsMedium(13))
                            .foregroundColor(
                                selectedLeaveType == leaveType.Leave_Name
                                ? .white
                                : .appBlack
                            )
                            .multilineTextAlignment(.leading)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity
                            )
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        selectedLeaveType == leaveType.Leave_Name
                                        ? Color.appPrimary
                                        : Color.white
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        Color.gray.opacity(0.35),
                                        lineWidth: 1
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct LeaveDateView: View {
    
    @Binding var FromDate: Date?
    @Binding var selectedDayType: String
    @Binding var selectedHalf: String?
    
    @State private var leaveDate = "Leave Date"
    @State private var selectedLeaveDate = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            HStack {
                Login_TxtfieldName(
                    titleName: $leaveDate,
                    foreGroundColour: .gray,
                    fontSize: 13
                )
                
                Spacer()
            }
            
            CustommDatePicker(
                selectedDate: $FromDate,
                selectedDayType: $selectedDayType,
                selectedDateText: $selectedLeaveDate, selectedHalf: $selectedHalf,
                SelectMod: "F",
                placeholder: "Select a Date"
            )
            
            Spacer().frame(height: 5)
            
            if FromDate != nil {
                HStack {
                    Text(
                        selectedDayType == "Half day"
                        ? "No of days: 0.5"
                        : "No of days: 1"
                    )
                    .font(.poppinsMedium(13))
                    .foregroundColor(.appPrimary)

                    Spacer()
                }
            }
        }
    }
}

struct LeaveReasonView: View {
    @State private var leaveReason = "Reason for Leave"
    @Binding var reasonText : String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Login_TxtfieldName(
                    titleName: $leaveReason,
                    foreGroundColour: .gray,
                    fontSize: 13
                )
                
                Spacer()
            }
            
            ZStack(alignment: .topLeading) {
                
                TextEditor(text: $reasonText)
                    .font(.poppinsMedium(14))
                    .padding(8)
                    .frame(height: 120)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                Color.gray.opacity(0.4),
                                lineWidth: 1
                            )
                    )
                
                if reasonText.isEmpty {
                    Text("Enter the leave reason")
                        .font(.poppinsMedium(14))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 13)
                        .padding(.top, 16)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

struct Attachment: View {

    @ObservedObject var vm: AuthenticationViewModel

    @Binding var selectedItem: PhotosPickerItem?
    @Binding var selectedImage: UIImage?
    @Binding var fileName: String?
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 0) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {

                VStack(spacing: 12) {

                    ImageV(
                        name: "paperclip",
                        type: .systemName,
                        color: .appPrimary
                    )

                    Text("Add Attachment")
                        .font(.poppinsSemiBold(14))
                        .foregroundColor(.appPrimary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            Color.appPrimary,
                            style: StrokeStyle(
                                lineWidth: 2,
                                dash: [6, 5]
                            )
                        )
                )
                .cornerRadius(10)
                .padding(.vertical)
            }
            .buttonStyle(.plain)

            if let uploadedURL = vm.uploadedImageURL {

                HStack(spacing: 10) {

                    Text(uploadedURL)
                        .font(.poppinsMedium(14))
                        .foregroundColor(.black)
                        .lineLimit(2)

                    Spacer()

                    Button {
                        print("Download \(uploadedURL)")
                    } label: {

                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.green)
                    }

                    // Remove
                    Button {

                        selectedItem = nil
                        selectedImage = nil
                        fileName = nil

                        vm.uploadedImageURL = nil

                    } label: {

                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
        }

        .onChange(of: selectedItem) { newItem in

            guard let newItem = newItem else {
                return
            }

            Task {

                do {
                    if let data = try await newItem.loadTransferable(
                        type: Data.self
                    ),
                    let image = UIImage(data: data) {

                        selectedImage = image

                        await vm.uploadImage(
                            selectedImage: image
                        )
                    }

                }
                catch {
                    print(
                        "Image loading failed: \(error.localizedDescription)"
                    )
                }
            }
        }
    }
    
    
}

#Preview {
    LeaveFormView()
}
