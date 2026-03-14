import SwiftUI

struct CategoryListView: View {
    @StateObject private var viewModel = CategoryViewModel()
    @ObservedObject private var hintManager = HintManager.shared
    @State private var showingAdd = false
    @State private var editingCategory: CDCategory?

    var body: some View {
        NavigationView {
            Group {
                if viewModel.categories.isEmpty {
                    EmptyStateView(
                        icon: "folder.badge.plus",
                        title: "No Categories",
                        message: "Add categories to organize your transactions."
                    )
                } else {
                    ZStack(alignment: .top) {
                        List {
                            Section {
                                ForEach(viewModel.expenseCategories) { category in
                                    CategoryRowView(category: category)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            editingCategory = category
                                        }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            if viewModel.canDelete(category) {
                                                Button(role: .destructive) {
                                                    viewModel.deleteCategory(category)
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                        }
                                }
                            } header: {
                                Label("Expense", systemImage: "arrow.up.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.subheadline.weight(.semibold))
                            }

                            Section {
                                ForEach(viewModel.incomeCategories) { category in
                                    CategoryRowView(category: category)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            editingCategory = category
                                        }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            if viewModel.canDelete(category) {
                                                Button(role: .destructive) {
                                                    viewModel.deleteCategory(category)
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                        }
                                }
                            } header: {
                                Label("Income", systemImage: "arrow.down.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.subheadline.weight(.semibold))
                            }
                        }
                        .listStyle(.insetGrouped)

                        HintBubble(hint: .categoryTap)
                            .padding(.horizontal)
                            .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.fetchCategories()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    hintManager.showIfNeeded(.categoryTap)
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEditCategoryView(viewModel: viewModel, category: nil)
            }
            .sheet(item: $editingCategory) { category in
                AddEditCategoryView(viewModel: viewModel, category: category)
            }
        }
    }
}
