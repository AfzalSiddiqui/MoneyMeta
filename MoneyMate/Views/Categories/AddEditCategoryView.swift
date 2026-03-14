import SwiftUI

struct AddEditCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CategoryViewModel

    let category: CDCategory?

    @State private var name: String = ""
    @State private var colorHex: String = "#FF6B6B"
    @State private var icon: String = "ellipsis.circle.fill"
    @State private var categoryType: CategoryType = .expense

    private let icons = [
        "fork.knife", "car.fill", "bag.fill", "doc.text.fill",
        "gamecontroller.fill", "heart.fill", "book.fill", "ellipsis.circle.fill",
        "house.fill", "gift.fill", "airplane", "music.note",
        "pawprint.fill", "leaf.fill", "dumbbell.fill", "cup.and.saucer.fill",
        "banknote.fill", "laptopcomputer", "chart.line.uptrend.xyaxis",
        "creditcard.fill", "calendar.badge.clock", "arrow.uturn.left.circle.fill"
    ]

    private var isEditing: Bool { category != nil }

    var body: some View {
        NavigationView {
            Form {
                Section("Type") {
                    Picker("Category Type", selection: $categoryType) {
                        ForEach(CategoryType.allCases, id: \.self) { type in
                            Text(type.label).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Name") {
                    TextField("Category name", text: $name)
                }

                Section("Color") {
                    ColorPickerGridView(selectedHex: $colorHex)
                }

                Section("Icon") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        ForEach(icons, id: \.self) { iconName in
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(icon == iconName ? Color(hex: colorHex).opacity(0.2) : Color.clear)
                                    .frame(height: 44)
                                Image(systemName: iconName)
                                    .font(.title2)
                                    .foregroundColor(icon == iconName ? Color(hex: colorHex) : .secondary)
                            }
                            .onTapGesture {
                                icon = iconName
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section {
                    HStack {
                        Text("Preview")
                        Spacer()
                        CategoryIconView(colorHex: colorHex, icon: icon)
                        Text(name.isEmpty ? "Category" : name)
                            .foregroundColor(name.isEmpty ? .secondary : .primary)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Category" : "New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategory()
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let category = category {
                    name = category.wrappedName
                    colorHex = category.wrappedColorHex
                    icon = category.wrappedIcon
                    categoryType = category.wrappedCategoryType
                }
            }
        }
    }

    private func saveCategory() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        if let category = category {
            viewModel.updateCategory(category, name: trimmed, colorHex: colorHex, icon: icon, categoryType: categoryType)
        } else {
            viewModel.addCategory(name: trimmed, colorHex: colorHex, icon: icon, categoryType: categoryType)
        }
    }
}
