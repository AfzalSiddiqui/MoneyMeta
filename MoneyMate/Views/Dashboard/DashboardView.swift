import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @StateObject private var transactionVM = TransactionViewModel()
    @State private var showingAddTransaction = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    MonthlySummaryCard(viewModel: viewModel)

                    QuickAddButton {
                        showingAddTransaction = true
                    }

                    RecentTransactionsView(transactions: viewModel.recentTransactions)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("MoneyMate")
            .onAppear {
                viewModel.refresh()
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddEditTransactionView(viewModel: transactionVM, transaction: nil)
                    .onDisappear {
                        viewModel.refresh()
                    }
            }
        }
    }
}
