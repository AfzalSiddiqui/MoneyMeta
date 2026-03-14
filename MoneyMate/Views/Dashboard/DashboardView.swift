import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @StateObject private var transactionVM = TransactionViewModel()
    @ObservedObject private var hintManager = HintManager.shared
    @State private var showingAddTransaction = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    MonthlySummaryCard(viewModel: viewModel)
                        .hint(.monthNav, edge: .bottom)

                    HintBubble(hint: .dashboard)
                        .padding(.horizontal)

                    QuickAddButton {
                        showingAddTransaction = true
                    }
                    .hint(.addTransaction, edge: .top)

                    RecentTransactionsView(transactions: viewModel.recentTransactions)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("MoneyMate")
            .onAppear {
                viewModel.refresh()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    hintManager.showIfNeeded(.dashboard)
                }
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
