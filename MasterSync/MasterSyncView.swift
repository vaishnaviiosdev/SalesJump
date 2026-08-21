//
//  MasterSyncView.swift
//  SalesJump
//
//  Created by Saneforce on 11/08/26.
//

import SwiftUI

struct MasterSyncView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showMenu = false
    @State private var isLoading = false
    @State private var ShowBottomSheet:Bool = false
    @State private var rotation: Double = 0
    @StateObject private var toast = Toastmanager.shared
    @StateObject var viewModel: MasterSyncViewModel = .init()
    
    @EnvironmentObject var router: AppRouter
    @Environment(\.colorScheme) var colorScheme
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    let isLogin:Bool?

    var body: some View {
        ZStack {
            
            if colorScheme == .dark {
                Color(.systemGroupedBackground)
            }else{
                
                Color(UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00))
            }
            
            VStack {
                
                HStack {
                    
                    
                    
                    Image("Up Arrow")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: isPad ? 34 : 24,
                            height: isPad ? 34 : 24
                        )
                        .foregroundStyle(.primary)
                        .rotationEffect(.degrees(-90))
                        .padding(.leading, 20)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    
                    Spacer()
                    
                    Text("Master Sync")
                        .font(.poppinsMedium( isPad ? 18:16))
                    
                    Spacer()
                    
                    Button {
                        showMenu.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .foregroundColor(.primary)
                    }
                    .padding(.trailing, 20)
                    .popover(isPresented: $showMenu, arrowEdge: .top) {
                        menuContent
                            .frame(width: 180)
                            .presentationCompactAdaptation(.popover)
                    }

                    
                }.frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background( colorScheme == .dark ? Color(.systemGroupedBackground): Color.white)
                    .shadow(color: Color.black.opacity(0.12), radius: 3, x: 0, y: 2)
                    .padding(.top, 35)
                
              
                
                if SessionManager.shared.SF_Type == "2" {
                    HStack{
                        
                        Text(viewModel.HeadquarterName == "" ? "Select Headquarter" : viewModel.HeadquarterName)
                            .font(.poppinsMedium(14))
                            .foregroundStyle(viewModel.HeadquarterName == "" ? Color.gray : Color.primary)
                            .padding(.leading,8)
                        
                        Spacer()
                        
                        Image("Down Arrow Outline")
                            .padding(.trailing,8)
                        
                    }.frame(height: 45)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray, lineWidth: 0.5)
                            
                        )
                        .padding(.horizontal)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            Task {
                            await viewModel.fetchSubordinate()
                                if viewModel.Subordinates.isEmpty{
                                    Toastmanager.shared.show("No data available")
                                    return
                                }
                            ShowBottomSheet = true
                            }
                        }
                    
                }
                
                
                VStack {
                    ScrollView(showsIndicators: false) {
                        ForEach(viewModel.MasterSyncAPI.indices, id: \.self) { index in
                            let item = viewModel.MasterSyncAPI[index]
                            HStack {
                                Text(item.Name)
                                    .font(.poppinsMedium( isPad ? 16:14))
                                    .padding(.leading, 10)
                                Spacer()
                                if item.ShowContandLoading{
                                    
                                    Text("\(item.Count)")
                                        .font(.poppinsMedium( isPad ? 16:14))
                                        .frame(height:  isPad ? 34:24)
                                        .padding(.horizontal, 4)
                                        .foregroundColor(
                                            colorScheme == .dark
                                            ? .white
                                            : .appPrimary
                                        )
                                        .background(
                                            (
                                                colorScheme == .dark
                                                ? Color.white.opacity(0.12)
                                                : Color.appPrimaryLight
                                            )
                                            .clipShape(
                                                RoundedRectangle(cornerRadius: 4)
                                            )
                                        )
                                        .contentTransition(.numericText())
                                        .animation(
                                            .easeOut(duration: 0.8),
                                            value: item.Count
                                        )
                                    
                                    if item.error{
                                        TimelineView(.animation) { context in
                                        Image("caution")
                                            .resizable()
                                            .frame(width: isPad ? 34:24, height: isPad ? 34:24)
                                            
                                    }
                                    }else{
                                    TimelineView(.animation) { context in
                                        
                                        Image("Reload")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: isPad ? 26:16, height: isPad ? 26:16)
                                            .foregroundStyle(Color.appPrimary)
                                            .rotationEffect(
                                                .degrees(
                                                    item.isLoading
                                                    ? context.date.timeIntervalSinceReferenceDate
                                                        .truncatingRemainder(dividingBy: 1) * 360
                                                    : 0
                                                )
                                            )
                                    }
                                }
                                    
                                }
                                  
                                Color.clear
                                    .frame(width: 10)
                                
                                
                            }.frame(maxWidth: .infinity)
                                .frame(height: isPad ? 80:60)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    Task{
                                        await viewModel.SyncData(Index: index)
                                    }
                                }
                            Divider()
                        }
                    }
                }.background( colorScheme == .dark ?  Color(.systemGroupedBackground):Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 3)
                    .padding(.horizontal)
                    .padding(.vertical,10)
                
                Spacer()
            }
            
            .sheet(isPresented: $ShowBottomSheet) {
                BottomSheet(Subordinates: $viewModel.Subordinates,HeadquarterName: $viewModel.HeadquarterName, HeadquarterID: $viewModel.getHqSf_Code)
                           .presentationDetents([.fraction(0.8), .large])
                           .presentationDragIndicator(.visible)
                   }
            
            .onChange(of: viewModel.getHqSf_Code) { _, newValue in
                Task {
                    for index in viewModel.MasterSyncAPI.indices {
                        if viewModel.MasterSyncAPI[index].Master_Name != "quickactionsetup" &&
                           viewModel.MasterSyncAPI[index].Master_Name != "subordinate" {
                            viewModel.MasterSyncAPI[index].HqSf_Code = newValue
                        }
                    }

                    await viewModel.SavetodaySyncSubordinate(subordinate: newValue)
                    await viewModel.SyncAll()
                }
            }
            
            .onChange(of: viewModel.AllApiCompleted){ _,isCompleted in
                if isLogin == true{
                    
                    guard isCompleted else { return }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        router.MasterSyncSuccess()
                    }
                }
            }
            
            .overlay {
                if toast.isShowing {
                    ToastView(message: toast.message)
                        .padding(.bottom, 80)
                        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottom)
                }
            }

        }.navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.all)
            .onAppear{
              
                Task{
                    await viewModel.FetchMyDayplan(isLogIn: isLogin ?? false)
                }
                
                
            }
          
    }
    
    
    private var menuContent: some View {
        VStack(alignment: .leading, spacing: 0) {

            Button {
                
             
                Task{
                   await viewModel.SyncAll()
                }
                
                showMenu = false
            } label: {
                Text("Sync all")
                    .font(.poppinsMedium(14))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .frame(height: 45)
            }

            Divider()

            Button {
                Task{
                   await viewModel.ClearData()
                    router.logout()
                }
                
                showMenu = false
            } label: {
                Text("Clear Data")
                    .font(.poppinsMedium(14))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .frame(height: 45)
            }
        }
    }
}



struct BottomSheet : View {
    @Environment(\.dismiss) private var dismiss
    @State var Serch: String = ""
    @Binding var Subordinates: [Subordinate]
    @Binding var HeadquarterName:String
    @Binding var HeadquarterID:String

    var filteredList: [Subordinate] {
        
        if Serch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return Subordinates
        }
        return Subordinates.filter {
            $0.name?.localizedCaseInsensitiveContains(Serch) ?? false
        }
    }
    var body: some View {
        VStack {

            VStack {
                HStack {

                    Text("Select  Headquarters")
                        .font(.poppinsSemiBold(16))
                        .padding(.leading,16)
                        .padding(.bottom,16)
                        .padding(.top,20)

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image("Close Button")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.trailing,16)
                            .padding(.bottom,16)
                            .padding(.top,20)
                    }
                }
                .padding(.horizontal, 10)

            Rectangle()
                    .frame(height: 0.5)
                    .foregroundStyle(Color.gray.opacity(0.6))
                
            }
           

            VStack {

                HStack {

                    Image("search")
                        .resizable()
                        .frame(width: 20,height: 20).padding(.leading,8)

                    TextField("Search", text: $Serch)
                        .font(.system(size: 14, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                        .padding(.trailing, 8)
                }
                .frame(height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray, lineWidth: 0.5)
                ).padding(.horizontal,10)
                    .padding(.top,5)

        
                ScrollView {
                    ForEach(filteredList.indices, id: \.self) { index in
                        let item = filteredList[index]

                        HStack {

                            Text(item.name ?? "")
                                .font(.poppinsMedium(13))

                            Spacer()
                        }
                        .frame(height: 40)
                        .contentShape(Rectangle())
                        .padding(.horizontal,10)
                        .onTapGesture {
                            let item = filteredList[index]
                            HeadquarterName = item.name ?? "-"
                            HeadquarterID = item.id ?? ""
                            dismiss()
                        }
                        Rectangle()
                                .frame(height: 0.5)
                                .foregroundStyle(Color.gray.opacity(0.6))
                    }
                }
                

                Spacer()
            }
            
        }
    }
    
}
