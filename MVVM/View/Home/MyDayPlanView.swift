//
//  MyDayPlanView.swift
//  SalesJump
//
//  Created by Saneforce on 17/08/26.
//

import SwiftUI
import AVFAudio

struct MyDayPlanView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = MyDayPlanViewModel()
    @Environment(\.colorScheme) var colorScheme
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @StateObject private var player = AudioPlayerManager()
    
    var body: some View {
        ZStack{
            if colorScheme == .dark {
                Color(.systemGroupedBackground)
            }else{
                Color(UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00))
            }
            
            VStack{
                
                ZStack {
                    
                    Text("Day Plan")
                        .font(.poppinsMedium(isPad ? 18 : 16))
                        .foregroundStyle(Color.primary)

                    HStack {
                        Image("Up Arrow")
                            .renderingMode(.template)
                              .resizable()
                              .foregroundStyle(Color.primary)
                            .frame(width: 24, height: 24)
                            .rotationEffect(.degrees(-90))
                            .padding(.leading, 20)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }

                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(uiColor: .systemBackground))
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.12), radius: 3, x: 0, y: 2)
                .padding(.top, 35)
                
                ScrollView(showsIndicators: true){
                    VStack(spacing: 15){
                        
                        SelectionFieldView(title: "Work Type",value: viewModel.WorTypName == "" ? "Select" : viewModel.WorTypName,isMandatory: true) {
                            print("Work Type")
                            
                            viewModel.ShowWorkTypsheet = true
                            
                        }
                        
                        if SessionManager.shared.SF_Type == "2" {
                            SelectionFieldView(title: "Head Quater",value: viewModel.HeadQuarterName == "" ? "Select" : viewModel.HeadQuarterName,isMandatory: true) {
                                print("Head Quater")
                                
                                viewModel.ShowHQsheet = true
                            }
                        }
                        // Setup Based Name Was Change
                        if UserSetup.shared.IsDistributorBased == true {
                            SelectionFieldView(title: "Distributor",value: viewModel.DistributorName == "" ? "Select" : viewModel.DistributorName,isMandatory: true) {
                                print("Distributor")
                                viewModel.ShowDistributorsheet = true
                            }
                        }
                        
                        // Setup Based Name Was Change
                        SelectionFieldView(title: "Route",value: viewModel.RouteName == "" ? "Select" : viewModel.RouteName,isMandatory: true) {
                            print("Route")
                            viewModel.ShowRouteheet = true
                        }
                        
                        // Setup Based Name Was Change
                        VStack{
                            SelectionFieldView(title: "Outlet",value:"Select",isMandatory: true) {
                                print("Outlet")
                                viewModel.ShowRetailerSheet = true
                            }
                            
                            
                            if viewModel.SelecetdRetailer != nil{
                                VStack{
                                    
                                    if isPad {
                                        
                                        HStack(spacing: 8) {
                                            ForEach(Array((viewModel.SelecetdRetailer ?? []).prefix(3)), id: \.id) { retailer in
                                                
                                                HStack {
                                                    Text(retailer.name ?? "")
                                                        .font(.poppinsSemiBold(isPad ? 16 : 14))
                                                        .foregroundStyle(colorScheme == .dark ? .white : Color.appPrimary)
                                                        .padding(.leading, 6)
                                                    
                                                    Image("Close Button (1)")
                                                        .resizable()
                                                        .frame(width: isPad ? 26 : 16,
                                                               height: isPad ? 26 : 16)
                                                        .padding(.trailing, 6)
                                                        .onTapGesture{
                                                            if let index = viewModel.SelecetdRetailer?.firstIndex(where: { $0.id == retailer.id }) {
                                                                viewModel.SelecetdRetailer?.remove(at: index)
                                                            }
                                                        }
                                                }
                                                .frame(height: isPad ? 42 : 32)
                                                .background(
                                                    colorScheme == .dark
                                                    ? Color(.systemGray5)
                                                    : Color.appPrimaryLight
                                                )
                                                .cornerRadius(4)
                                                
                                            }
                                            let count = viewModel.SelecetdRetailer?.count ?? 0
                                            if count > 3 {
                                                Text("+\(count - 3) More")
                                                    .font(.poppinsSemiBold(isPad ? 16 : 14))
                                                    .foregroundStyle(colorScheme == .dark ? .white : Color.appPrimary)
                                                    .padding(.horizontal, 10)
                                                    .frame(height: isPad ? 42 : 32)
                                                    .background(
                                                        colorScheme == .dark
                                                        ? Color(.systemGray5)
                                                        : Color.appPrimaryLight
                                                    )
                                                    .cornerRadius(4)
                                                    .onTapGesture {
                                                        viewModel.ShowRetailerSheet = true
                                                    }
                                            }
                                            Spacer()
                                        }
                                    }else{
                                        
                                        VStack{
                                            HStack(spacing: 8) {
                                                ForEach(Array((viewModel.SelecetdRetailer ?? []).prefix(2)), id: \.id) { retailer in
                                                    
                                                    HStack {
                                                        Text(retailer.name ?? "")
                                                            .font(.poppinsSemiBold(isPad ? 16 : 14))
                                                            .foregroundStyle(colorScheme == .dark ? .white : Color.appPrimary)
                                                            .padding(.leading, 6)
                                                        
                                                        Image("Close Button (1)")
                                                            .resizable()
                                                            .frame(width: isPad ? 26 : 16,
                                                                   height: isPad ? 26 : 16)
                                                            .padding(.trailing, 6)
                                                            .onTapGesture{
                                                                
                                                                if let index = viewModel.SelecetdRetailer?.firstIndex(where: { $0.id == retailer.id }) {
                                                                    viewModel.SelecetdRetailer?.remove(at: index)
                                                                }
                                                            }
                                                    }
                                                    .frame(height: isPad ? 42 : 32)
                                                    .background(
                                                        colorScheme == .dark
                                                        ? Color(.systemGray5)
                                                        : Color.appPrimaryLight
                                                    )
                                                    .cornerRadius(4)
                                                }
                                                Spacer()
                                            }
                                            
                                            
                                            let count = viewModel.SelecetdRetailer?.count ?? 0
                                            if count > 2 {
                                                HStack(spacing: 8) {
                                                    HStack {
                                                        Text(viewModel.SelecetdRetailer?[2].name ?? "")
                                                            .font(.poppinsSemiBold(isPad ? 16 : 14))
                                                            .foregroundStyle(colorScheme == .dark ? .white : Color.appPrimary)
                                                            .padding(.leading, 6)
                                                        
                                                        Image("Close Button (1)")
                                                            .resizable()
                                                            .frame(width: isPad ? 26 : 16,
                                                                   height: isPad ? 26 : 16)
                                                            .padding(.trailing, 6)
                                                            .onTapGesture{
                                                                
                                                                if (viewModel.SelecetdRetailer?.count ?? 0) > 2 {
                                                                    viewModel.SelecetdRetailer?.remove(at: 2)
                                                                }
                                                            }
                                                    }
                                                    .frame(height: isPad ? 42 : 32)
                                                    .background(
                                                        colorScheme == .dark
                                                        ? Color(.systemGray5)
                                                        : Color.appPrimaryLight
                                                    )
                                                    .cornerRadius(4)
                                                    
                                                    
                                                    
                                                    
                                                    if count > 3{
                                                        if count > 3 {
                                                            Text("+\(count - 3) More")
                                                                .font(.poppinsSemiBold(isPad ? 16 : 14))
                                                                .foregroundStyle(colorScheme == .dark ? .white : Color.appPrimary)
                                                                .padding(.horizontal, 10)
                                                                .frame(height: isPad ? 42 : 32)
                                                                .background(
                                                                    colorScheme == .dark
                                                                    ? Color(.systemGray5)
                                                                    : Color.appPrimaryLight
                                                                )
                                                                .cornerRadius(4)
                                                                .onTapGesture{
                                                                    
                                                                    viewModel.ShowRetailerSheet = true
                                                                    
                                                                }
                                                        }
                                                    }
                                                    Spacer()
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }.padding(.top,10)
                                
                                
                            }
                            
                        }
                        .padding(12)
                        .background( colorScheme == .dark ? Color(.secondarySystemBackground):Color.white)
                        .cornerRadius(4)
                        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.1),radius: 4,x: 0,y: 2)
                        
                        
                        WorkWithView(selectedType: $viewModel.selectedType)
                        
                        VStack {
                            if viewModel.selectedType == "Joint Work"{
                                VStack{
                                    SelectionFieldView(title: "Joint Work",value:"Select",isMandatory: true) {
                                        print("Joint Work")
                                        
                                        viewModel.ShowJointWorkheet = true
                                    }
                                    
                                    
                                    if viewModel.SelecetdJointWork != nil{
                                        VStack{
                                            
                                            if isPad {
                                                
                                                HStack(spacing: 8) {
                                                    ForEach(Array((viewModel.SelecetdJointWork ?? []).prefix(3)), id: \.id) { retailer in
                                                        
                                                        HStack {
                                                            Text(retailer.name ?? "")
                                                                .font(.poppinsSemiBold(isPad ? 16 : 14))
                                                                .foregroundStyle(Color.appPrimary)
                                                                .padding(.leading, 6)
                                                            
                                                            Image("Close Button (1)")
                                                                .resizable()
                                                                .frame(width: isPad ? 26 : 16,
                                                                       height: isPad ? 26 : 16)
                                                                .padding(.trailing, 6)
                                                                .onTapGesture {
                                                                    if let index = viewModel.SelecetdJointWork?.firstIndex(where: { $0.id == retailer.id }) {
                                                                        viewModel.SelecetdJointWork?.remove(at: index)
                                                                    }
                                                                    
                                                                }
                                                        }
                                                        .frame(height: isPad ? 42 : 32)
                                                        .background(Color.appPrimaryLight)
                                                        .cornerRadius(4)
                                                    }
                                                    let count = viewModel.SelecetdJointWork?.count ?? 0
                                                    if count > 3 {
                                                        Text("+\(count - 3) More")
                                                            .font(.poppinsSemiBold(isPad ? 16 : 14))
                                                            .foregroundStyle(.appPrimary)
                                                            .padding(.horizontal, 10)
                                                            .frame(height: isPad ? 42 : 32)
                                                            .background(Color.appPrimaryLight)
                                                            .cornerRadius(4)
                                                            .onTapGesture{
                                                                
                                                                viewModel.ShowJointWorkheet = true
                                                                
                                                            }
                                                    }
                                                    Spacer()
                                                }
                                            }else{
                                                
                                                VStack{
                                                    HStack(spacing: 8) {
                                                        ForEach(Array((viewModel.SelecetdJointWork ?? []).prefix(2)), id: \.id) { retailer in
                                                            
                                                            HStack {
                                                                Text(retailer.name ?? "")
                                                                    .font(.poppinsSemiBold(isPad ? 16 : 14))
                                                                    .foregroundStyle(colorScheme == .dark ? .white : Color.appPrimary)
                                                                    .padding(.leading, 6)
                                                                
                                                                Image("Close Button (1)")
                                                                    .resizable()
                                                                    .frame(width: isPad ? 26 : 16,
                                                                           height: isPad ? 26 : 16)
                                                                    .padding(.trailing, 6)
                                                                    .onTapGesture {
                                                                        if let index = viewModel.SelecetdJointWork?.firstIndex(where: { $0.id == retailer.id }) {
                                                                            viewModel.SelecetdJointWork?.remove(at: index)
                                                                        }
                                                                        
                                                                    }
                                                            }
                                                            .frame(height: isPad ? 42 : 32)
                                                            .background(
                                                                colorScheme == .dark
                                                                ? Color(.systemGray5)
                                                                : Color.appPrimaryLight
                                                            )
                                                            .cornerRadius(4)
                                                        }
                                                        Spacer()
                                                    }
                                                    
                                                    
                                                    let count = viewModel.SelecetdJointWork?.count ?? 0
                                                    if count > 2 {
                                                        HStack(spacing: 8) {
                                                            HStack {
                                                                Text(viewModel.SelecetdJointWork?[2].name ?? "")
                                                                    .font(.poppinsSemiBold(isPad ? 16 : 14))
                                                                    .foregroundStyle(colorScheme == .dark ? .white : Color.appPrimary)
                                                                    .padding(.leading, 6)
                                                                
                                                                Image("Close Button (1)")
                                                                    .resizable()
                                                                    .frame(width: isPad ? 26 : 16,
                                                                           height: isPad ? 26 : 16)
                                                                    .padding(.trailing, 6)
                                                                    .onTapGesture{
                                                                        
                                                                        if (viewModel.SelecetdJointWork?.count ?? 0) > 2 {
                                                                            viewModel.SelecetdJointWork?.remove(at: 2)
                                                                        }
                                                                    }
                                                            }
                                                            .frame(height: isPad ? 42 : 32)
                                                            .background(
                                                                colorScheme == .dark
                                                                ? Color(.systemGray5)
                                                                : Color.appPrimaryLight
                                                            )
                                                            .cornerRadius(4)
                                                            
                                                            
                                                            if count > 3{
                                                                if count > 3 {
                                                                    Text("+\(count - 3) More")
                                                                        .font(.poppinsSemiBold(isPad ? 16 : 14))
                                                                        .foregroundStyle(colorScheme == .dark ? .white : Color.appPrimary)
                                                                        .padding(.horizontal, 10)
                                                                        .frame(height: isPad ? 42 : 32)
                                                                        .background(
                                                                            colorScheme == .dark
                                                                            ? Color(.systemGray5)
                                                                            : Color.appPrimaryLight
                                                                        )
                                                                        .cornerRadius(4)
                                                                        .onTapGesture{
                                                                            
                                                                            viewModel.ShowJointWorkheet = true
                                                                            
                                                                        }
                                                                }
                                                            }
                                                            Spacer()
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }.padding(.top,10)
                                        
                                        
                                    }
                                    
                                }
                                .padding(12)
                                .background( colorScheme == .dark ? Color(.secondarySystemBackground):Color.white)
                                .cornerRadius(4)
                                .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.1),radius: 4,x: 0,y: 2)
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .opacity
                                    )
                                )
                            }
                            
                        }.animation(.easeInOut(duration: 0.25), value: viewModel.selectedType)
                        
                        
                        RemarkView(remarks: $viewModel.remarks,audioFilePath: $viewModel.audioFilePath)
                        
                        if !viewModel.audioFilePath.isEmpty{
                        HStack(spacing: 12) {
                            
                            Image(systemName:
                                    player.isPlaying
                                  ? "pause.fill"
                                  : "play.fill")
                            .resizable()
                            .frame(
                                width: isPad ? 30 : 20,
                                height: isPad ? 30 : 20
                            )
                            .padding(.leading,8)
                            .onTapGesture {
                                player.playPause()
                            }
                            
                            ProgressView(
                                value: player.currentTime,
                                total: max(player.duration, 1)
                            )
                            .frame(maxWidth: .infinity)
                            
                            Text(
                                "\(player.timeString(player.currentTime))/\(player.timeString(player.duration))"
                            )
                            .font(.caption)
                            
                            Image(systemName: "trash.fill")
                                .resizable()
                                .frame(
                                    width: isPad ? 30 : 20,
                                    height: isPad ? 30 : 20
                                )
                                .foregroundColor(.red)
                                .padding(.trailing,8)
                                .onTapGesture {
                                    
                                    player.deleteAudio(at: viewModel.audioFilePath)
                                    viewModel.audioFilePath = ""
                                }
                        }
                        .frame(height: isPad ? 60 : 50)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color(UIColor(red: 0.85,green: 0.85,blue: 0.85,alpha: 1.00)),lineWidth: 1
                                       )
                        )
                    
                        
                    }
                           
                        
                        
                        VStack(alignment: .center){
                            Spacer()
                            Image("Camera")
                                .resizable()
                                .frame(width: isPad ? 30 : 20, height: isPad ? 30 : 20)
                            
                            
                            Text("Capture Photo")
                                .font(.poppinsMedium(isPad ? 18 : 16))
                                .foregroundStyle(.appPrimary)
                                
                            
                            Spacer()
                            
                        }.frame(height: isPad ? 104 : 84)
                            .frame(maxWidth: .infinity)
                        .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.appPrimary,style: StrokeStyle(lineWidth: 1,dash: [4, 2]))
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                            showCamera = true
                            }
                            .fullScreenCover(isPresented: $showCamera) {
                                       FaceCameraView { image in
                                           self.capturedImage = image
                                       }
                                   }
                        
                        
                        
                        
                        
                    }.padding(10)
                    
                }
                Spacer()
                
                VStack {

                    Button {
                        print("Submit")
                      
                    } label: {
                        Text("Submit")
                            .font(.poppinsMedium(isPad ? 18 : 16))
                            .foregroundStyle(.white)
                            .frame(height: isPad ? 61 : 51)
                            .frame(maxWidth: .infinity)
                            .background(Color.appPrimary)
                            .cornerRadius(4)
                    }
                    .padding(.horizontal, 10)

                }
                .frame(height: isPad ? 112 : 92)
                .background(Color(.systemBackground))
                .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.08),radius: 4,x: 0,y: -2)
                
            }
            
            .sheet(isPresented: $viewModel.ShowWorkTypsheet) {

                CommonSelectionBottomSheet(
                    title: "Select Work Type",
                    items: viewModel.AllWorkType,
                    displayName: { $0.name ?? "" }
                ) { item in
                    viewModel.WorTypName = item.name ?? ""
                    viewModel.WorTypID = item.id ?? 0
                }.presentationDetents([.fraction(0.8), .large])
                    .presentationDragIndicator(.visible)
            }
            
            
            .sheet(isPresented: $viewModel.ShowHQsheet) {

                CommonSelectionBottomSheet(
                    title: "Select Headquater",
                    items: viewModel.Subordinates,
                    displayName: { $0.name ?? "" }
                ) { item in
                    viewModel.HeadQuarterName = item.name ?? ""
                    viewModel.HeadQuarterID = item.id ?? ""
                  
                }.presentationDetents([.fraction(0.8), .large])
                    .presentationDragIndicator(.visible)
            }
            
            
            
            .sheet(isPresented: $viewModel.ShowDistributorsheet) {

                CommonSelectionBottomSheet(
                    title: "Select Distributor",
                    items: viewModel.AllDistributorList,
                    displayName: { $0.name ?? "" }
                ) { item in
                    print(item)
                    viewModel.DistributorName = item.name ?? ""
                    viewModel.DistributorID = item.id ?? 0
                    
                    viewModel.IsDistributorBasedRouteFilter(id: String(item.id ?? 0))
                    
                    viewModel.RouteName = ""
                    viewModel.RouteNameID = nil
                    
                }.presentationDetents([.fraction(0.8), .large])
                    .presentationDragIndicator(.visible)
            }
            
            
            .sheet(isPresented: $viewModel.ShowRouteheet) {

                CommonSelectionBottomSheet(
                    title: "Select Route",
                    items: viewModel.RouteList,
                    displayName: { $0.name ?? "" }
                ) { item in
                    print(item)
                    viewModel.RouteName = item.name ?? ""
                    viewModel.RouteNameID = item.id ?? 0
                    
                }.presentationDetents([.fraction(0.8), .large])
                    .presentationDragIndicator(.visible)
            }
            
            .sheet(isPresented: $viewModel.ShowJointWorkheet) {

                CommonMultiCheckboxBottomSheet(
                    title: "Joint Work",
                    items: viewModel.AllJointWorkList,
                    preSelectedIDs: Set(
                    (viewModel.SelecetdJointWork ?? []).map { $0.id }
                    ),
                    displayName: { $0.name ?? "" }
                ) { selectedItems in
                   
                    viewModel.SelecetdJointWork = selectedItems
                

                    let names = selectedItems.compactMap { $0.name }
                    print(names.joined(separator: ", "))
                }.presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
            
            
            .sheet(isPresented: $viewModel.ShowRetailerSheet) {

                CommonMultiCheckboxBottomSheet(
                    title: "Please Select Retailer",
                    items: viewModel.AllRetailerList,
                    preSelectedIDs: Set(
                               (viewModel.SelecetdRetailer ?? []).map { $0.id }
                           ),
                    displayName: { $0.name ?? "" }
                ) { selectedItems in
                    
                    viewModel.SelecetdRetailer = selectedItems
                    

                    let names = selectedItems.compactMap { $0.name }
                    print(names.joined(separator: ", "))
                }.presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
            
   
            .onChange(of: viewModel.audioFilePath) { oldValue, newValue in

                if !newValue.isEmpty {

                    let url = URL(fileURLWithPath: newValue)

                    player.loadAudio(url: url)
                }
            }
            
        }.navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.all)
            .onAppear{
                
                Task{
                    await self.viewModel.getLocalData()
                    
                    await self.viewModel.FetchMyDayplan()
                    
                    print(viewModel.AllWorkType)
                }
                
            }
    }
}



struct WorkWithView: View {
    
    @Binding  var selectedType:String
    @Namespace private var animation
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack(spacing: 2) {
                Text("Work With")
                    .font(.poppinsMedium(12))
                    .foregroundStyle(.appTextGrey)
                
                Text("*")
                    .font(.poppinsMedium(12))
                    .foregroundStyle(.red)
                
            }
            .padding(.leading, 3)
            
            
            
            
            HStack(spacing: 4) {
                
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                       selectedType = "Self"
                    }
                } label: {
                    ZStack {
                        
                        if selectedType == "Self" {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.appPrimary)
                                .matchedGeometryEffect(
                                    id: "SEGMENT",
                                    in: animation
                                )
                        }
                        
                        Text("Self")
                            .font(.poppinsMedium(
                                UIDevice.current.userInterfaceIdiom == .pad ? 16 : 14
                            ))
                            .frame(maxWidth: .infinity)
                            .frame(
                                height: UIDevice.current.userInterfaceIdiom == .pad ? 48 : 36
                            )
                            .foregroundColor(
                               selectedType == "Self"
                                ? .white
                                : .primary
                            )
                    }
                }
                
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedType = "Joint Work"
                    }
                } label: {
                    ZStack {
                        
                        if selectedType == "Joint Work" {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.appPrimary)
                                .matchedGeometryEffect(
                                    id: "SEGMENT",
                                    in: animation
                                )
                        }
                        
                        Text("Joint Work")
                            .font(.poppinsMedium(
                                UIDevice.current.userInterfaceIdiom == .pad ? 16 : 14
                            ))
                            .frame(maxWidth: .infinity)
                            .frame(
                                height: UIDevice.current.userInterfaceIdiom == .pad ? 48 : 36
                            )
                            .foregroundColor(
                                selectedType == "Joint Work"
                                ? .white
                                : .primary
                            )
                    }
                }
            }
            .padding(4)
            .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 44)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        Color(.separator),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
        }
    }
}




struct RemarkView: View {
    @Binding  var remarks:String
    @Binding var audioFilePath: String
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var recorder = AudioRecorder()
    @State private var animateMic = false
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

     var body: some View {
         VStack(alignment: .leading, spacing: isPad ? 8 : 4) {

             HStack(spacing: 2) {
                 Text("Remarks")
                     .font(.poppinsMedium(isPad ? 14 : 12))
                     .foregroundStyle(.appTextGrey)
                 Spacer()
             }
             .padding(.leading, 3)
             
             
             VStack{
                 HStack{
                     Spacer()
                     HStack{
                         
                         Image("Template")
                             .resizable()
                             .frame(width: isPad ? 30 : 20, height: isPad ? 30 : 20)
                             .padding(.leading, 8)
                         
                         
                         
                         Text("Choose Template")
                             .font(.poppinsMedium(14))
                             .foregroundStyle(Color.appPrimary)
                             .padding(.trailing, 8)
                         
                         
                     }.frame(height: isPad ? 38 : 28)
                         .background(
                            colorScheme == .dark
                            ? Color(.secondarySystemBackground)
                            : Color.appPrimaryLight
                         )
                         .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 2
                            )
                         )
                 }
                 
                 Spacer()
                 
                 ZStack(alignment: .topLeading) {
                     
                     if remarks.isEmpty {
                         Text("Enter the Remarks (or) Select from Template")
                             .font(.poppinsMedium(isPad ? 14 : 12))
                             .foregroundColor(.gray)
                             .padding(.top, 16)
                             .padding(.leading, 8)
                     }
                     
                     TextEditor(text: $remarks)
                         .font(.poppinsMedium(isPad ? 14 : 12))
                         .scrollContentBackground(.hidden)
                         .background(Color.clear)
                 }
                 Spacer()
                 
                 if audioFilePath.isEmpty{
                 HStack{
                     Spacer()
                     HStack(spacing: 12) {
                         
                         if recorder.isRecording {
                             
                             VoiceWaveView(level: recorder.audioLevel)
                             
                             Text("Recording...")
                                 .font(.caption)
                                 .foregroundColor(.red)
                         }
                         
                         Image("Microphone")
                             .resizable()
                             .frame(
                                width: isPad ? 42 : 32,
                                height: isPad ? 42 : 32
                             )
                             .padding(.trailing, 8)
                             .padding(.bottom, 8)
                             .onTapGesture {
                                 
                                 if recorder.isRecording {
                                     
                                     recorder.stopRecording()
                                     
                                     if let audioURL = recorder.recordedAudioURL {
                                         
                                         audioFilePath = audioURL.path
                                         
                                         
                                     }
                                     
                                 } else {
                                     
                                     AVAudioApplication.requestRecordPermission { granted in
                                         
                                         DispatchQueue.main.async {
                                             
                                             if granted {
                                                 recorder.startRecording()
                                             } else {
                                                 print("Microphone Permission Denied")
                                             }
                                         }
                                     }
                                 }
                             }
                     }
                 }
             }
                 
                 
             } .frame(height: isPad ? 156 : 126)
                 .frame(maxWidth: .infinity)
                 .overlay(
                     RoundedRectangle(cornerRadius: 4)
                         .stroke(Color(UIColor(red: 0.85,green: 0.85,blue: 0.85,alpha: 1.00)),lineWidth: 1
                         )
                 )
                 .contentShape(Rectangle())
             
             

         }
         
         
    }
}



struct CommonSelectionBottomSheet<T>: View {

    @Environment(\.dismiss) private var dismiss

    @State private var searchText: String = ""
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    let title: String
    let items: [T]
    let displayName: (T) -> String
    let onSelect: (T) -> Void

    var filteredItems: [T] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return items
        }

        return items.filter {
            displayName($0).localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack {

   
            VStack {
                HStack {

                    Text(title)
                        .font(.poppinsSemiBold( isPad ? 18:16))
                        .padding(.leading, 16)
                        .padding(.vertical, 20)

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image("Close Button")
                            .resizable()
                            .frame(width:isPad ? 34:24, height: isPad ? 34:24)
                            .padding(.trailing, 16)
                    }
                }
                .padding(.horizontal, 10)

                Rectangle()
                    .frame(height: 0.5)
                    .foregroundStyle(Color.gray.opacity(0.6))
            }

            HStack {
                Image("search")
                    .resizable()
                    .frame(width: isPad ? 30:20, height: isPad ? 30:20)
                    .padding(.leading, 8)

                TextField("Search", text: $searchText)
                    .font(.system(size: isPad ? 16:14, weight: .medium))
                    .frame(height:isPad ?  40:30)
                    .padding(.trailing, 8)
            }
            .frame(height: isPad ? 46:36)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray, lineWidth: 0.5)
            }
            .padding(.horizontal, 10)
            .padding(.top, 5)

            ScrollView {
                LazyVStack(spacing: isPad ?  10:8) {
                    ForEach(filteredItems.indices, id: \.self) { index in

                        let item = filteredItems[index]

                    
                            HStack {
                                Text(displayName(item))
                                    .font(.poppinsMedium(isPad ? 15:13))

                                Spacer()
                            }
                            .frame(height: isPad ? 50:40)
                            .contentShape(Rectangle())
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                onSelect(item)
                                dismiss()
                            }

                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundStyle(Color.gray.opacity(0.6))
                        
                    }
                }
            }

            Spacer()
        }
    }
}





struct CommonMultiCheckboxBottomSheet<T: Identifiable>: View {

    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var selectedIDs: Set<T.ID> = []
   

        let title: String
        let items: [T]
        let preSelectedIDs: Set<T.ID>
        let displayName: (T) -> String
        let onDone: ([T]) -> Void

        init(
            title: String,
            items: [T],
            preSelectedIDs: Set<T.ID> = [],
            displayName: @escaping (T) -> String,
            onDone: @escaping ([T]) -> Void
        ) {
            self.title = title
            self.items = items
            self.preSelectedIDs = preSelectedIDs
            self.displayName = displayName
            self.onDone = onDone

            _selectedIDs = State(initialValue: preSelectedIDs)
        }

    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var filteredItems: [T] {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        if text.isEmpty {
            return items
        }

        return items.filter {
            displayName($0)
                .localizedCaseInsensitiveContains(text)
        }
    }

    var body: some View {

        VStack {

            // Header
            HStack {

                Text(title)
                    .font(.poppinsSemiBold(isPad ? 18 : 16))

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image("Close Button")
                        .resizable()
                        .frame(
                            width: isPad ? 34 : 24,
                            height: isPad ? 34 : 24
                        )
                }
            }
            .padding()

            Divider()

            // Search
            HStack {

                Image("search")
                    .resizable()
                    .frame(
                        width: isPad ? 30 : 20,
                        height: isPad ? 30 : 20
                    )

                TextField("Search", text: $searchText)
                    .font(.system(size: isPad ? 16 : 14))
            }
            .padding(.horizontal, 10)
            .frame(height: isPad ? 46 : 36)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.gray.opacity(0.5))
            }
            .padding(.horizontal)

            // List
            ScrollView {

                LazyVStack(spacing: 0) {

                    ForEach(filteredItems) { item in

                        HStack(spacing: 12) {

                            // Left Side Checkbox
                            Image(
                                systemName:
                                    selectedIDs.contains(item.id)
                                ? "checkmark.square.fill"
                                : "square"
                            )
                            .font(
                                .system(
                                    size: isPad ? 24 : 20
                                )
                            )

                            Text(displayName(item))
                                .font(
                                    .poppinsMedium(
                                        isPad ? 15 : 13
                                    )
                                )

                            Spacer()
                        }
                        .frame(height: isPad ? 55 : 45)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
                        .onTapGesture {

                            if selectedIDs.contains(item.id) {
                                selectedIDs.remove(item.id)
                            } else {
                                selectedIDs.insert(item.id)
                            }
                        }

                        Divider()
                    }
                }
            }

            // Done
            Button {

                let selectedItems = items.filter {
                    selectedIDs.contains($0.id)
                }

                onDone(selectedItems)

                dismiss()

            } label: {

                Text("Done")
                    .font(.poppinsSemiBold(16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}
