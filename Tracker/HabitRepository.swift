import SwiftUI

protocol HabitRepositoryProtocol {
    func getHabits() async -> [HabitModel]
    func save(_ habits: [HabitModel])
}

final class HabitRepositoryMock<T>: HabitRepositoryProtocol where T: StorageProtocol, T.Model == HabitModel {
    
    private var storage: T

    init(with storage: T) {
        self.storage = storage
    }
    
    func getHabits() async -> [HabitModel] {
        return await storage.getAll()
    }
    
    func save(_ habits: [HabitModel]) {
        storage.save(habits)
    }
}

final class HabitRepository<T>: HabitRepositoryProtocol where T: StorageProtocol, T.Model == HabitModel {

    private var storage: T
    
    init(with storage: T) {
        self.storage = storage
    }
    
    func getHabits() async -> [HabitModel] {
        return await storage.getAll()
    }

    func save(_ habits: [HabitModel]) {
        storage.save(habits)
    }
}
