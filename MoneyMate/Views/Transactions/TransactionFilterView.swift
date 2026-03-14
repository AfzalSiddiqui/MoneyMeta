import SwiftUI

struct TransactionFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TransactionViewModel
    @StateObject private var categoryVM = CategoryViewModel()

    @State private var localType: TransactionType? = nil
    @State private var localCategory: CDCategory? = nil
    @State private var localStartDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var localEndDate: Date = Date()
    @State private var useDateRange = false

    var body: some View {
        NavigationView {
            Form {
                Section("Transaction Type") {
                    Picker("Type", selection: $localType) {
                        Text("All").tag(nil as TransactionType?)
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            Text(type.label).tag(type as TransactionType?)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Category") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(title: "All", isSelected: localCategory == nil) {
                                localCategory = nil
                            }
                            ForEach(categoryVM.categories) { cat in
                                FilterChip(
                                    title: cat.wrappedName,
                                    isSelected: localCategory == cat,
                                    color: Color(hex: cat.wrappedColorHex)
                                ) {
                                    localCategory = cat
                                }
                            }
                        }
                    }
                }

                Section("Date Range") {
                    Toggle("Filter by date", isOn: $useDateRange)
                    if useDateRange {
                        DatePicker("From", selection: $localStartDate, displayedComponents: .date)
                        DatePicker("To", selection: $localEndDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        viewModel.clearFilters()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        viewModel.selectedType = localType
                        viewModel.selectedCategory = localCategory
                        viewModel.startDate = useDateRange ? localStartDate : nil
                        viewModel.endDate = useDateRange ? localEndDate : nil
                        dismiss()
                    }
                }
            }
            .onAppear {
                localType = viewModel.selectedType
                localCategory = viewModel.selectedCategory
                if let start = viewModel.startDate {
                    localStartDate = start
                    useDateRange = true
                }
                if let end = viewModel.endDate {
                    localEndDate = end
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var color: Color = .accentColor
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? color.opacity(0.2) : Color(.systemGray6))
                .foregroundColor(isSelected ? color : .primary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? color : Color.clear, lineWidth: 1)
                )
        }
    }
}
