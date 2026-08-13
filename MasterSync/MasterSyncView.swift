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
    @State private var rotation: Double = 0
    @StateObject var viewModel: MasterSyncViewModel = .init()

    var body: some View {
        ZStack {
            
            Color(UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00))
            
            VStack {
                
                HStack {
                    
                    Image("Up Arrow")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .rotationEffect(.degrees(-90))
                        .padding(.leading, 20)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    
                    Spacer()
                    
                    Text("Master Sync")
                        .font(.poppinsMedium(16))
                    
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
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.12), radius: 3, x: 0, y: 2)
                    .padding(.top, 35)
                
                // Only Show Manger
                
                
                HStack{
                    
                    Text("Kanchipuram (Harris)")
                        .font(.poppinsMedium(14))
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
                
                
                VStack {
                    ScrollView(showsIndicators: false) {
                        ForEach(viewModel.MasterSyncAPI.indices, id: \.self) { index in
                            let item = viewModel.MasterSyncAPI[index]
                            HStack {
                                Text(item.Name)
                                    .font(.poppinsMedium(14))
                                    .padding(.leading, 10)
                                Spacer()
                                if item.ShowContandLoading{
                                    
                                    Text("\(item.Count)")
                                        .font(.poppinsMedium(14))
                                        .frame(height: 24)
                                        .padding(.horizontal, 4)
                                        .foregroundColor(.appPrimary)
                                        .background(
                                            Color.appPrimaryLight
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
                                            .frame(width: 24, height: 24)
                                            
                                    }
                                    }else{
                                    TimelineView(.animation) { context in
                                        
                                        Image("Reload")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 16, height: 16)
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
                                .frame(height: 60)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    Task{
                                        await viewModel.SyncData(Index: index)
                                    }
                                }
                            Divider()
                        }
                    }
                }.background(Color.white)
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
            

        }.navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.all)
          
    }
    
    
    private var menuContent: some View {
        VStack(alignment: .leading, spacing: 0) {

            Button {
                
                for index in viewModel.MasterSyncAPI.indices {
                    viewModel.MasterSyncAPI[index].ShowContandLoading = true
                    viewModel.MasterSyncAPI[index].isLoading = true
                    viewModel.MasterSyncAPI[index].Count = 0
                }
                
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
