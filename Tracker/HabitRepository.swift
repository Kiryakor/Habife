import SwiftUI

protocol HabitRepositoryProtocol {
    func getHabits() async -> [HabitModel]
    func save(_ habits: [HabitModel])
}

final class HabitRepositoryMock: HabitRepositoryProtocol {
    
    func getHabits() async -> [HabitModel] {
        return [
            HabitModel(name: "123", motivation: "123", progress: 0.7, color: .red, habitProgresses: []),
            HabitModel(name: "13223", motivation: "121233", progress: 0.54, color: .blue, habitProgresses: []),
            HabitModel(name: "qqe", motivation: "rwe", progress: 0.23, color: .black, habitProgresses: [])
        ]
    }
    
    func save(_ habits: [HabitModel]) {
    }
}

final class HabitRepository<T>: HabitRepositoryProtocol where T: StorageProtocol, T.Model == HabitModel {

    private var storage: T
    
    init(with storage: T) {
        self.storage = storage
    }
    
    // MARK: - Public
    
    func getHabits() async -> [HabitModel] {
        return await storage.getAll()
    }

    func save(_ habits: [HabitModel]) {
        storage.save(habits)
    }
}
