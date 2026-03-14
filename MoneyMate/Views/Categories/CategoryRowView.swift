import SwiftUI

struct CategoryRowView: View {
    let category: CDCategory

    var body: some View {
        HStack(spacing: 12) {
            CategoryIconView(
                colorHex: category.wrappedColorHex,
                icon: category.wrappedIcon
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(category.wrappedName)
                    .font(.body)
                if category.isDefault {
                    Text("Default")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text("\(category.transactionArray.count)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
