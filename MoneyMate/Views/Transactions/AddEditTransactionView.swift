import SwiftUI

struct AddEditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TransactionViewModel
    @StateObject private var categoryVM = CategoryViewModel()

    let transaction: CDTransaction?

    @State private var amount: String = ""
    @State private var type: TransactionType = .expense
    @State private var note: String = ""
    @State private var date: Date = Date()
    @State private var selectedCategory: CDCategory?

    private var isEditing: Bool { transaction != nil }

    private var matchingCategories: [CDCategory] {
        switch type {
        case .expense: return categoryVM.expenseCategories
        case .income: return categoryVM.incomeCategories
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Type") {
                    Picker("Type", selection: $type) {
                        ForEach(TransactionType.allCases, id: \.self) { t in
                            Text(t.label).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: type) { _ in
                        if let cat = selectedCategory,
                           !matchingCategories.contains(cat) {
                            selectedCategory = nil
                        }
                    }
                }

                Section("Amount") {
                    HStack {
                        Text(Locale.current.currencySymbol ?? "$")
                            .foregroundColor(.secondary)
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                }

                Section(type == .expense ? "Expense Category" : "Income Category") {
                    if matchingCategories.isEmpty {
                        Text("No categories available")
                            .foregroundColor(.secondary)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(matchingCategories) { cat in
                                    VStack(spacing: 4) {
                                        CategoryIconView(
                                            colorHex: cat.wrappedColorHex,
                                            icon: cat.wrappedIcon,
                                            size: 44
                                        )
                                        .overlay(
                                            Circle()
                                                .stroke(Color.accentColor, lineWidth: selectedCategory == cat ? 2 : 0)
                                                .frame(width: 48, height: 48)
                                        )
                                        Text(cat.wrappedName)
                                            .font(.caption2)
                                            .lineLimit(1)
                                    }
                                    .onTapGesture {
                                        selectedCategory = cat
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Details") {
                    TextField("Note (optional)", text: $note)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle(isEditing ? "Edit Transaction" : "New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTransaction()
                        dismiss()
                    }
                    .disabled(!isValidAmount)
                }
            }
            .onAppear {
                if let t = transaction {
                    amount = String(format: "%.2f", t.amount)
                    type = t.transactionType
                    note = t.wrappedNote
                    date = t.wrappedDate
                    selectedCategory = t.category
                }
            }
        }
    }

    private var isValidAmount: Bool {
        guard let value = Double(amount), value > 0 else { return false }
        return true
    }

    private func saveTransaction() {
        guard let value = Double(amount) else { return }
        let trimmedNote = note.trimmingCharacters(in: .whitespaces)
        if let t = transaction {
            viewModel.updateTransaction(t, amount: value, type: type, note: trimmedNote.isEmpty ? nil : trimmedNote, date: date, category: selectedCategory)
        } else {
            viewModel.addTransaction(amount: value, type: type, note: trimmedNote.isEmpty ? nil : trimmedNote, date: date, category: selectedCategory)
        }
    }
}
