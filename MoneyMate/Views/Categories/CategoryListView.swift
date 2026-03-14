import SwiftUI

struct CategoryListView: View {
    @StateObject private var viewModel = CategoryViewModel()
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
                    List {
                        ForEach(viewModel.categories) { category in
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
                    }
                    .listStyle(.insetGrouped)
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
            .sheet(isPresented: $showingAdd) {
                AddEditCategoryView(viewModel: viewModel, category: nil)
            }
            .sheet(item: $editingCategory) { category in
                AddEditCategoryView(viewModel: viewModel, category: category)
            }
        }
    }
}
