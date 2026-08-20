//
//  MenuView.swift
//  SalesJump
//
//  Created by San eforce on 11/08/26.
//


import SwiftUI

enum MenuRoute: Hashable {
    case customForms
    case expenseEntry
    case orderConfirmation
    case geoTagging
    case payments
    case tourPlan
    case circular
    case missedDateEntry
    case leaveForm
    case leaveHistory
}

struct MenuView: View {

    @State private var searchTxt = ""
    @State private var selectedMenu: MenuItem?
    @State private var navigationPath = NavigationPath()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(\.colorScheme) var colorScheme

    let menuItems: [MenuItem] = [

        MenuItem(
            title: "Orders",
            imageName: "Group 32",
            subItems: [
                SubMenuItem(
                    title: "Retailer Order",
                    imageName: "Secondary Order"
                ),
                SubMenuItem(
                    title: "Primary Order",
                    imageName: "Primary Order"
                ),
                SubMenuItem(
                    title: "SuperStockist Order",
                    imageName: "SuperStockiest"
                )
            ],
            route: nil
        ),

        MenuItem(
            title: "Return",
            imageName: "Return",
            subItems: [
                SubMenuItem(
                    title: "Primary Order Return",
                    imageName: "ReturnPrimary"
                ),
                SubMenuItem(
                    title: "Retailer Order Return",
                    imageName: "ReturnSecondary"
                )
            ],
            route: nil
        ),

        MenuItem(
            title: "Custom Forms",
            imageName: "Custom Form",
            subItems: nil,
            route: .customForms
        ),

        MenuItem(
            title: "Expense Entry",
            imageName: "Group 43",
            subItems: nil,
            route: .expenseEntry
        ),

        MenuItem(
            title: "Order Confirmation",
            imageName: "confirmation 1",
            subItems: nil,
            route: .orderConfirmation
        ),

        MenuItem(
            title: "Geo Tagging",
            imageName: "Geo Tagging",
            subItems: nil,
            route: .geoTagging
        ),

        MenuItem(
            title: "Payments",
            imageName: "Payments",
            subItems: nil,
            route: .payments
        ),

        MenuItem(
            title: "Retailer List",
            imageName: "Retailer",
            subItems: [
                SubMenuItem(
                    title: "View Retailer List",
                    imageName: "Shop"
                ),
                SubMenuItem(
                    title: "Add New Retailer",
                    imageName: "Shop_Add"
                ),
                SubMenuItem(
                    title: "Edit Retailer",
                    imageName: "Shop_Add"
                )
            ],
            route: nil
        ),

        MenuItem(
            title: "Distributor List",
            imageName: "Stockiest",
            subItems: [
                SubMenuItem(
                    title: "View Distributor List",
                    imageName: "ReturnPrimary"
                ),
                SubMenuItem(
                    title: "Add Distributor",
                    imageName: "Shop_Add"
                )
            ],
            route: nil
        ),

        MenuItem(
            title: "Route List",
            imageName: "Route",
            subItems: [
                SubMenuItem(
                    title: "View Route List",
                    imageName: "Route (1)"
                ),
                SubMenuItem(
                    title: "Add Route",
                    imageName: "Add Route"
                )
            ],
            route: nil
        ),

        MenuItem(
            title: "Leave",
            imageName: "Leave",
            subItems: [
                SubMenuItem(
                    title: "Leave Form",
                    imageName: "Leave Form"
                ),
                SubMenuItem(
                    title: "Leave History",
                    imageName: "History"
                )
            ],
            route: nil
        ),

        MenuItem(
            title: "Tour Plan",
            imageName: "Layer_1",
            subItems: nil,
            route: .tourPlan
        ),

        MenuItem(
            title: "Closing Stock",
            imageName: "Stock",
            subItems: [
                SubMenuItem(
                    title: "Closing Stock (RETAILER)",
                    imageName: "Shop_Add"
                )
            ],
            route: nil
        ),

        MenuItem(
            title: "Circular",
            imageName: "Circular",
            subItems: nil,
            route: .circular
        ),

        MenuItem(
            title: "Missed Date Entry",
            imageName: "Group 42",
            subItems: nil,
            route: .missedDateEntry
        ),

        MenuItem(
            title: "Competition",
            imageName: "Group 119",
            subItems: [
                SubMenuItem(
                    title: "Leaderboard",
                    imageName: "Reward"
                ),
                SubMenuItem(
                    title: "Rewards",
                    imageName: "Reward (1)"
                ),
                SubMenuItem(
                    title: "Contest",
                    imageName: "Contest"
                ),
                SubMenuItem(
                    title: "Badges",
                    imageName: "Badges"
                ),
                SubMenuItem(
                    title: "Battle",
                    imageName: "Battle"
                )
            ],
            route: nil
        ),

        MenuItem(
            title: "Others",
            imageName: "Others",
            subItems: [
                SubMenuItem(
                    title: "Outlet Review",
                    imageName: "Outlet Review"
                )
            ],
            route: nil
        )
    ]

    var filteredItems: [MenuItem] {

        if searchTxt.isEmpty {
            return menuItems
        }

        return menuItems.filter {
            $0.title.localizedCaseInsensitiveContains(searchTxt)
        }
    }

    var body: some View {

        GeometryReader { geo in

            let isPad = UIDevice.current.userInterfaceIdiom == .pad

            let horizontalPadding: CGFloat = 16

            let spacing: CGFloat = isPad ? 30 : 10

            let cardWidth =
                (geo.size.width
                 - (horizontalPadding * 2)
                 - (spacing * 2)) / 3

            ZStack {

                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    searchTxtfield(
                        searchTxt: $searchTxt,
                        onSearch: { query in
                            searchTxt = query
                        }
                    )
                    .padding(.horizontal, 8)
                    .padding(.top, 15)
                    .padding(.bottom, 15)

                    ScrollView(
                        .vertical,
                        showsIndicators: false
                    ) {

                        menuContent(
                            cardWidth: cardWidth,
                            spacing: spacing,
                            horizontalPadding: horizontalPadding
                        )
                        .padding(.bottom, 120)
                    }
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Text("Submitted Calls")
                            .font(.poppinsMedium(14))
                            .frame(
                                maxWidth: horizontalSizeClass == .regular ? .infinity : nil
                            )
                            .frame(height: 40)
                            .padding(.horizontal,14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.gray, lineWidth: 0.5)
                            )
                            .contentShape(Rectangle())
                        Spacer()
                        NavigationLink {
                            MasterSyncView(isLogin:false)
                        } label: {

                        Text("Master Sync")
                            .font(.poppinsMedium(14))
                            .frame(
                                maxWidth: horizontalSizeClass == .regular ? .infinity : nil
                            )
                            .frame(height: 40)
                            .padding(.horizontal,14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.gray, lineWidth: 0.5)
                            )
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                           
                        Spacer()
                        Text("Outbox")
                            .font(.poppinsMedium(14))
                            .frame(
                                maxWidth: horizontalSizeClass == .regular ? .infinity : nil
                            )
                            .frame(height: 40)
                            .padding(.horizontal,14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.gray, lineWidth: 0.5)
                            )
                            .contentShape(Rectangle())
                        Spacer()
                        
                    }.frame(maxWidth: .infinity)
                        .frame(height: 67)
                        .overlay(
                            TopRoundedRectangle(radius: 12)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                        )
                        .background(Color(.systemBackground))

                }
              
            }
            .navigationDestination(for: MenuRoute.self) { route in

                switch route {

                case .customForms:
                    demoView()

                case .expenseEntry:
                    demoView()

                case .orderConfirmation:
                    demoView()

                case .geoTagging:
                    demoView()

                case .payments:
                    demoView()

                case .tourPlan:
                    demoView()

                case .circular:
                    demoView()

                case .missedDateEntry:
                    demoView()
                    
                case .leaveForm:
                    LeaveFormView()
                    
                case .leaveHistory:
                    LeaveHistoryView()
                }
            }
        }
    }
    
    private var bottomButtons: some View {

        HStack(spacing: 12) {

            bottomButton(title: "Submitted Calls")

            bottomButton(title: "Master Sync")

            bottomButton(title: "Outbox")
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.12),
                    radius: 6,
                    x: 0,
                    y: -2
                )
        )
    }
    
    private func bottomButton(title: String) -> some View {

        Button {
            print(title)
        } label: {

            Text(title)
                .font(
                    .poppinsMedium(
                        UIDevice.current.userInterfaceIdiom == .pad
                        ? 16
                        : 13
                    )
                )
                .foregroundColor(.appBlack)
                .frame(
                    maxWidth: .infinity
                )
                .frame(
                    height: UIDevice.current.userInterfaceIdiom == .pad
                    ? 50
                    : 40
                )
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            Color.gray.opacity(0.3),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func menuContent(
        cardWidth: CGFloat,
        spacing: CGFloat,
        horizontalPadding: CGFloat
    ) -> some View {

        let items = filteredItems

        VStack(spacing: spacing) {

            ForEach(Array(stride(from: 0, to: items.count, by: 3)), id: \.self) { startIndex in

                let endIndex = min(startIndex + 3, items.count)
                let rowItems = Array(items[startIndex..<endIndex])

                HStack(spacing: spacing) {

                    ForEach(rowItems) { item in

                        MenuViewList(
                            item: item,
                            width: cardWidth,
                            isSelected: selectedMenu?.id == item.id
                        ) {
                            toggleMenu(item)
                        }
                    }

                    if rowItems.count < 3 {
                        ForEach(0..<(3 - rowItems.count), id: \.self) { _ in
                            Color.clear
                                .frame(width: cardWidth)
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)

                if let selectedMenu = selectedMenu,
                   let subItems = selectedMenu.subItems,
                   !subItems.isEmpty,
                   rowItems.contains(where: { $0.id == selectedMenu.id }) {

                    SubMenuSection(
                        items: subItems,
                        width: UIScreen.main.bounds.width,
                        horizontalPadding: horizontalPadding
                    )
                }
            }
        }
    }
    
    struct SubMenuSection: View {

        let items: [SubMenuItem]
        let width: CGFloat
        let horizontalPadding: CGFloat

        var body: some View {

            VStack(spacing: 0) {

                ForEach(items) { item in

                    if item.title == "Leave Form" {

                        NavigationLink(value: MenuRoute.leaveForm) {

                            subMenuRow(item: item)
                        }

                    }
                    else if item.title == "Leave History" {

                        NavigationLink(value: MenuRoute.leaveHistory) {

                            subMenuRow(item: item)
                        }

                    }
                    else {

                        Button {
                            print("Navigate to:", item.title)
                        } label: {

                            subMenuRow(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
            .background(Color.white)
        }

        @ViewBuilder
        private func subMenuRow(item: SubMenuItem) -> some View {

            HStack(spacing: 15) {

                ZStack {

                    Circle()
                        .fill(
                            Color.appPrimary.opacity(0.12)
                        )
                        .frame(
                            width: width * 0.10,
                            height: width * 0.10
                        )

                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: width * 0.05,
                            height: width * 0.05
                        )
                }

                Text(item.title)
                    .font(
                        .poppinsSemiBold(
                            UIDevice.current.userInterfaceIdiom == .pad
                            ? 18 : 13
                        )
                    )
                    .foregroundColor(.appBlack)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.poppinsMedium(13))
                    .foregroundColor(.appBlack)
                    .fontWeight(.bold)
                    .padding(.trailing, 8)
            }
            .padding(5)
            .frame(
                maxWidth: .infinity,
                minHeight: 50
            )
        }
    }

    private func toggleMenu(_ item: MenuItem) {

        if selectedMenu?.id == item.id {
            selectedMenu = nil
        }
        else {
            selectedMenu = item
        }
    }

    private func navigateToSubMenu(
        _ item: SubMenuItem
    ) {
        print("Navigate to:", item.title)
    }
}

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let subItems: [SubMenuItem]?
    let route: MenuRoute?
}

struct SubMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct SubMenuRow: View {

    let item: SubMenuItem
    let width: CGFloat
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 15) {
                ZStack {

                    Circle()
                        .fill(
                            Color.appPrimary.opacity(0.12)
                        )
                        .frame(
                            width: width * 0.10,
                            height: width * 0.10
                        )

                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: width * 0.05,
                            height: width * 0.05
                        )
                }

                Text(item.title)
                    .font(
                        .poppinsSemiBold(
                            UIDevice.current.userInterfaceIdiom == .pad
                            ? 18 : 13
                        )
                    )
                    .foregroundColor(.appBlack)
                    .lineLimit(nil)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.poppinsMedium(13))
                    .foregroundColor(.appBlack)
                    .fontWeight(.bold)
                    .padding(.trailing, 8)
            }
            .padding(5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(
                        Color.appPrimary.opacity(0.15)
                    )
                    .frame(height: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

struct ExpandedMenuList: View {
    
    let items: [SubMenuItem]
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ForEach(items) { item in
                
                Button {
                    print("Navigate to \(item.title)")
                } label: {
                    
                    HStack(spacing: 20) {
                        Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: 55,
                                height: 55
                            )
                            .background(
                                Circle()
                                    .fill(
                                        Color.appPrimary.opacity(0.12)
                                    )
                            )
                        
                        Text(item.title)
                            .font(.poppinsMedium(17))
                            .foregroundColor(.appBlack)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(
                                .system(
                                    size: 20,
                                    weight: .medium
                                )
                            )
                            .foregroundColor(.appBlack)
                    }
                    .padding(.horizontal, 25)
                    .frame(height: 75)
                }
                .buttonStyle(.plain)
                
                if item.id != items.last?.id {
                    Divider()
                        .padding(.horizontal, 20)
                }
            }
        }
        .background(Color.white)
    }
}

struct MenuViewList: View {

    let item: MenuItem
    let width: CGFloat
    let isSelected: Bool
    let action: () -> Void

    var body: some View {

        Button {
            action()
        } label: {

            VStack(alignment: .leading, spacing: 0) {

                ZStack(alignment: .top) {

                    Image("Ellipse 9")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            maxWidth: .infinity,
                            alignment: .top
                        )
                        .frame(
                            height: width * 0.72
                        )
                        .offset(
                            y: -(width * 0.20)
                        )

                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: width * 0.50,
                            height: width * 0.50
                        )
                        .padding(
                            UIDevice.current.userInterfaceIdiom == .pad
                            ? 8
                            : 5
                        )
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .offset(
                            x: UIDevice.current.userInterfaceIdiom == .pad
                            ? 40
                            : 20
                        )
                        .offset(y: 10)
                }

                Text(item.title)
                    .font(
                        .poppinsMedium(
                            UIDevice.current.userInterfaceIdiom == .pad
                            ? 18
                            : 13
                        )
                    )
                    .foregroundColor(.appBlack)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(
                        .leading,
                        UIDevice.current.userInterfaceIdiom == .pad
                        ? 50
                        : 16
                    )
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
            }
            .frame(width: width)
            .background(Color.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(
                        isSelected
                        ? Color.appPrimary
                        : Color.gray.opacity(0.25),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MenuView()
}
