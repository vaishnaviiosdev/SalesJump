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
    var backgroundColor: Color = .white
    var foregroundColor: Color = .white
    var borderColor: Color = .clear
    var borderWidth: CGFloat = 1         
    var fontWeight: Font.Weight = .medium
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.poppinsMedium(fontsize))
                .foregroundColor(foregroundColor)
                .frame(maxWidth: width, minHeight: height)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .cornerRadius(cornerRadius)
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

struct searchTxtfield: View {
    @Binding var searchTxt: String
    var onSearch: (String) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .fontWeight(.bold)
            
            Spacer()
            
            TextField(
                "",
                text: $searchTxt,
                prompt: Text("Search")
                    .foregroundColor(.gray)
            )
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(.black)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.vertical, 8)
            .autocorrectionDisabled(true)
            .onChange(of: searchTxt) { newValue in
                onSearch(newValue)
            }
        }
        .padding(.horizontal, 12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.8), lineWidth: 1)
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
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

struct CustommDatePicker: View {
    
    @Binding var selectedDate: Date?
    @Binding var selectedDayType: String
    @State private var showPicker = false
    //@State private var selectedDayType = "Full day"
    @State private var firstHalf = "Select"
    @State private var secondHalf = "Select"
    @Binding var selectedDateText : String
    @Binding var selectedHalf: String?
    
    @State var SelectMod: String?
    @State var FromDate: Date?
    
    var placeholder: String = "Select Date"
    var dateRange: ClosedRange<Date>? = nil
    @State private var contentHeight: CGFloat = 0
    
    var body: some View {
        
        Button(action: {
            showPicker.toggle()
        }) {
            
            HStack {
                
                ZStack {
                    if !selectedDateText.isEmpty {
                        Text(selectedDateText)
                            .font(.poppinsMedium(14))
                            .foregroundColor(.black)
                    } else {
                        Text(placeholder)
                            .regularTextStyle(
                                size: 14,
                                foreground: .black
                            )
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                
                ImageV(
                    name: "Calendar",
                    type: .assetName,
                    width: 15,
                    height: 15
                )
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        Color.gray.opacity(0.4),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        
        .sheet(isPresented: $showPicker) {
            
            VStack(spacing: 0) {
                DatePicker(
                    "Select Date",
                    selection: Binding(
                        get: {
                            selectedDate ?? Date()
                        },
                        set: {
                            selectedDate = $0
                        }
                    ),
                    in: dateRange ??
                        Date.distantPast...Date.distantFuture,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button {
                        selectedDayType = "Full day"
                        selectedHalf = nil
                        firstHalf = "Select"
                        secondHalf = "Select"

                        if let date = selectedDate {
                            selectedDateText = date.formattedString()
                        }

                    } label: {
                        Text("Full day")
                            .font(.poppinsMedium(15))
                            .foregroundColor(.black)
                            //.frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                            .frame(height: 55)
                            .background(
                                selectedDayType == "Full day"
                                ? Color.appPrimary.opacity(0.15)
                                : Color.gray.opacity(0.25)
                            )
                            .cornerRadius(8)
                            //.padding(.horizontal)
                    }
                    
                    //Spacer()
                    
                    Button {
                        selectedDayType = "Half day"
                    } label: {

                        HStack(spacing: 10) {

                            Text("Half day")
                                .font(.poppinsMedium(15))
                                .foregroundColor(.black)
                                .fixedSize()

                            if selectedDayType == "Half day" {
                                Button {
                                    guard selectedDate != nil else { return }

                                    selectedHalf = "1st"
                                    firstHalf = "1st"
                                    selectedDayType = "Half day"

                                    selectedDateText = halfDayTitle("1st")

                                } label: {
                                    Text(
                                        selectedDate != nil
                                        ? halfDayTitle("1st")
                                        : "Select"
                                    )
                                    .font(.poppinsMedium(13))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                    //.frame(maxWidth: .infinity, maxHeight: .infinity)
                                    //.frame(width: 100, height: 35)
                                    .background(Color.white)
                                    .cornerRadius(6)
                                }
                                    
                                Button {
                                    guard selectedDate != nil else { return }

                                    selectedHalf = "2nd"
                                    secondHalf = "2nd"
                                    selectedDayType = "Half day"

                                    selectedDateText = halfDayTitle("2nd")

                                } label: {
                                    Text(
                                        selectedDate != nil
                                        ? halfDayTitle("2nd")
                                        : "Select"
                                    )
                                    .font(.poppinsMedium(13))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                    //.frame(maxWidth: .infinity, maxHeight: .infinity)
                                    //.frame(width: 100, height: 35)
                                    .background(Color.white)
                                    .cornerRadius(6)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            selectedDayType == "Half day"
                            ? Color.appPrimary.opacity(0.15)
                            : Color.gray.opacity(0.25)
                        )
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                
                Button {

                    if selectedDate == nil {
                        selectedDate =
                            dateRange?.lowerBound ?? Date()
                    }

                    showPicker = false

                } label: {

                    Text(selectedDateButtonTitle)
                    .regularTextStyle(
                        size: 16,
                        foreground: .white,
                        fontWeight: .bold
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appPrimary)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 10)
            }
            .presentationDetents([.large])
        }
    }
    
    private var selectedDateButtonTitle: String {

        guard selectedDate != nil else {
            return "Select Date"
        }

        if selectedDayType == "Full day" {
            return selectedDate!.formattedString()
        }

        if let selectedHalf = selectedHalf {
            return halfDayTitle(selectedHalf)
        }

        return selectedDate!.formattedString()
    }
    
    private func halfDayTitle(_ suffix: String) -> String {
        guard let date = selectedDate else {
            return "Select"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"

        return "\(formatter.string(from: date)) \(suffix)"
    }
}
