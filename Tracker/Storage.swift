import Foundation

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
