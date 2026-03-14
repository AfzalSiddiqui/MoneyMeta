import SwiftUI

@main
struct MoneyMateApp: App {
    let coreDataStack = CoreDataStack.shared

    init() {
        coreDataStack.seedDefaultCategories()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataStack.viewContext)
        }
    }
}
