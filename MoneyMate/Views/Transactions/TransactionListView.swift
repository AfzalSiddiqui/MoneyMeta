import SwiftUI

struct TransactionListView: View {
    @StateObject private var viewModel = TransactionViewModel()
    @State private var showingAdd = false
    @State private var showingFilter = false
    @State private var editingTransaction: CDTransaction?

    var body: some View {
        NavigationView {
            Group {
                if viewModel.transactions.isEmpty {
                    EmptyStateView(
                        icon: "creditcard",
                        title: "No Transactions",
                        message: "Tap + to add your first transaction."
                    )
                } else {
                    List {
                        if viewModel.hasActiveFilters {
                            HStack {
                                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                    .foregroundColor(.accentColor)
                                Text("Filters active")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Button("Clear") {
                                    viewModel.clearFilters()
                                }
                                .font(.subheadline)
                            }
                        }

                        ForEach(viewModel.filteredTransactions) { transaction in
                            TransactionRowView(transaction: transaction)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    editingTransaction = transaction
                                }
                        }
                        .onDelete(perform: viewModel.deleteTransactions)
                    }
                    .listStyle(.insetGrouped)
                    .searchable(text: $viewModel.searchText, prompt: "Search transactions")
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingFilter = true
                    } label: {
                        Image(systemName: viewModel.hasActiveFilters
                              ? "line.3.horizontal.decrease.circle.fill"
                              : "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEditTransactionView(viewModel: viewModel, transaction: nil)
            }
            .sheet(item: $editingTransaction) { transaction in
                AddEditTransactionView(viewModel: viewModel, transaction: transaction)
            }
            .sheet(isPresented: $showingFilter) {
                TransactionFilterView(viewModel: viewModel)
            }
        }
    }
}
