import SwiftUI

@main
struct HabitApp: App {
    
    private let storage = DocumentsStorage<HabitModel>()
    
    var body: some Scene {
        WindowGroup {
            MainView(with: HabitRepository(with: storage))
        }
    }
}
