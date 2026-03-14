# How to Run MoneyMate

## Prerequisites
- macOS with Xcode 15+ installed
- iOS Simulator or physical iPhone

## Steps

1. **Open the project in Xcode**
   ```
   open MoneyMate.xcodeproj
   ```

2. **Set your development team**
   - Select the `MoneyMate` target in the project navigator
   - Go to **Signing & Capabilities**
   - Select your **Team** from the dropdown

3. **Select a simulator**
   - In the toolbar, pick an iPhone simulator (e.g. iPhone 15)

4. **Build & Run**
   - Press `Cmd + R` or click the **Play** button

## What to Expect

On first launch, default categories are seeded automatically:

### Expense Categories (10)
Food, Transport, Shopping, Bills, Entertainment, Health, Education, EMI, Credit Card, Other

### Income Categories (7)
Salary, Freelance, Investments, Gifts, Refunds, Rental Income, Other Income

### App Tabs
| Tab | Description |
|-----|-------------|
| **Dashboard** | Monthly income/expense/balance summary, recent transactions, quick-add button |
| **Transactions** | Full list with search, filters (type/category/date), swipe-to-delete, add/edit |
| **Charts** | Pie chart (spending by category) + bar chart (income vs expenses over time) |
| **Categories** | Grouped by Expense/Income, add/edit/delete with colors and icons |

### Interactive Hints
The app shows one-time onboarding hints as you explore each tab:
- **Dashboard** - Welcome message + quick-add tip + month navigation tip
- **Transactions** - Swipe-to-delete hint + filter tip
- **Charts** - Chart navigation and period selector tip
- **Categories** - Tap-to-edit hint

Each hint appears once and can be dismissed by tapping **"Got it"**. Hints never reappear after dismissal.

### EMI & Credit Card Tracking
- Use the **EMI** category for loan installments and monthly EMI payments
- Use the **Credit Card** category for credit card bill payments and charges
- Both appear under Expense categories with dedicated icons

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Signing error | Select your Apple ID team in Signing & Capabilities |
| Asset catalog build error | Restart Mac, then rebuild |
| No simulators listed | Open Xcode > Settings > Platforms > install iOS simulator |
| Categories not showing | Delete the app and reinstall to re-seed defaults |
