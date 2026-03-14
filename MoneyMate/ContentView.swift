import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }

            TransactionListView()
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet.rectangle")
                }

            ChartsContainerView()
                .tabItem {
                    Label("Charts", systemImage: "chart.pie.fill")
                }

            CategoryListView()
                .tabItem {
                    Label("Categories", systemImage: "folder.fill")
                }
        }
    }
}
