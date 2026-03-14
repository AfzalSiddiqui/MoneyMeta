import SwiftUI

enum HintKey: String, CaseIterable {
    case dashboard = "hint_dashboard"
    case addTransaction = "hint_add_transaction"
    case swipeDelete = "hint_swipe_delete"
    case filterTip = "hint_filter"
    case chartNav = "hint_chart_nav"
    case categoryTap = "hint_category_tap"
    case monthNav = "hint_month_nav"

    var title: String {
        switch self {
        case .dashboard: return "Welcome to MoneyMate!"
        case .addTransaction: return "Quick Add"
        case .swipeDelete: return "Swipe to Delete"
        case .filterTip: return "Filter Transactions"
        case .chartNav: return "Navigate Charts"
        case .categoryTap: return "Edit Categories"
        case .monthNav: return "Browse Months"
        }
    }

    var message: String {
        switch self {
        case .dashboard: return "Track your income and expenses. Tap the button below to add your first transaction."
        case .addTransaction: return "Tap + to add a new transaction. Switch between Income and Expense to see matching categories."
        case .swipeDelete: return "Swipe left on any transaction to delete it."
        case .filterTip: return "Tap the filter icon to narrow down by type, category, or date range."
        case .chartNav: return "Use the arrows to browse different months. Switch between 3M, 6M, and 1Y views."
        case .categoryTap: return "Tap any category to edit it. Categories are grouped by Income and Expense."
        case .monthNav: return "Use the arrows to navigate between months and track your spending over time."
        }
    }

    var icon: String {
        switch self {
        case .dashboard: return "hand.wave.fill"
        case .addTransaction: return "plus.circle.fill"
        case .swipeDelete: return "hand.draw.fill"
        case .filterTip: return "line.3.horizontal.decrease.circle.fill"
        case .chartNav: return "chart.pie.fill"
        case .categoryTap: return "folder.fill"
        case .monthNav: return "calendar"
        }
    }
}

final class HintManager: ObservableObject {
    static let shared = HintManager()

    @Published var activeHint: HintKey?

    private init() {}

    func shouldShow(_ hint: HintKey) -> Bool {
        !UserDefaults.standard.bool(forKey: hint.rawValue)
    }

    func showIfNeeded(_ hint: HintKey) {
        if shouldShow(hint) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                activeHint = hint
            }
        }
    }

    func dismiss(_ hint: HintKey) {
        UserDefaults.standard.set(true, forKey: hint.rawValue)
        withAnimation(.easeOut(duration: 0.2)) {
            if activeHint == hint {
                activeHint = nil
            }
        }
    }

    func resetAll() {
        for hint in HintKey.allCases {
            UserDefaults.standard.removeObject(forKey: hint.rawValue)
        }
    }
}

struct HintBubble: View {
    let hint: HintKey
    var edge: Edge = .bottom
    @ObservedObject var manager = HintManager.shared

    var body: some View {
        if manager.activeHint == hint {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: hint.icon)
                        .font(.title3)
                        .foregroundColor(.white)
                    Text(hint.title)
                        .font(.subheadline.weight(.bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        manager.dismiss(hint)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                Text(hint.message)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    manager.dismiss(hint)
                } label: {
                    Text("Got it")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accentColor.opacity(0.95))
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
            )
            .transition(.asymmetric(
                insertion: .scale(scale: 0.8).combined(with: .opacity),
                removal: .opacity
            ))
        }
    }
}

struct HintOverlay: ViewModifier {
    let hint: HintKey
    var edge: Edge = .bottom
    @ObservedObject var manager = HintManager.shared

    func body(content: Content) -> some View {
        content
            .overlay(alignment: edge == .bottom ? .bottom : .top) {
                HintBubble(hint: hint, edge: edge, manager: manager)
                    .padding(.horizontal, 16)
                    .offset(y: edge == .bottom ? 8 : -8)
            }
    }
}

extension View {
    func hint(_ hint: HintKey, edge: Edge = .bottom) -> some View {
        modifier(HintOverlay(hint: hint, edge: edge))
    }
}
