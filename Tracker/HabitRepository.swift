import SwiftUI

protocol HabitRepositoryProtocol {
    func getHabits() async -> [HabitModel]
    func save(_ habits: [HabitModel])
}


protocol StorageProtocol {
    associatedtype Model
    
    func getAll() async -> [Model]
    func save(_ models: [Model])
}

final class DocumentsStorage<Model: Codable>: StorageProtocol {
    
    func getAll() async -> [Model] {
        guard
            let readData = try? Data(contentsOf: habitsDataURL),
            let data = try? JSONDecoder().decode([Model].self, from: readData)
        else { return [] }
        
        return data
    }
    
    func save(_ models: [Model]) {
        guard let jsonData = try? JSONEncoder().encode(models.self) else { return }
        try? jsonData.write(to: habitsDataURL)
    }
    
    private let file = "documentsStorage.txt"
    
    private var habitsDataURL: URL {
        return documentDirectoryURL.appendingPathComponent(file)
    }
    
    private var documentDirectoryURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
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

extension Color {
    typealias SystemColor = UIColor
    
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        return (r, g, b, a)
    }
}
