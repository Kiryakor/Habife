import SwiftUI

@main
struct HabitApp: App {
    
    private let storage = DocumentsStorage<HabitModel>(
        with: Constants.StoragePath.DocumentsStoragePath.habitModels
    )
    
    var body: some Scene {
        WindowGroup {
            MainView(with: HabitRepository(with: storage))
        }
    }
}
