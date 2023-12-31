import Foundation

protocol StorageProtocol {
    associatedtype Model
    
    func getAll() async -> [Model]
    func save(_ models: [Model])
}

final class DocumentsStorage<Model: Codable>: StorageProtocol {
    
    init(with storagePath: String) {
        self.path = storagePath
    }
    
    // MARK: - Public
    
    func getAll() async -> [Model] {
        guard
            let readData = try? Data(contentsOf: fullPath),
            let data = try? JSONDecoder().decode([Model].self, from: readData)
        else { return [] }
        
        return data
    }
    
    func save(_ models: [Model]) {
        guard let jsonData = try? JSONEncoder().encode(models.self) else { return }
        try? jsonData.write(to: fullPath)
    }
    
    // MARK: - Private
    
    private var path: String
    
    private var fullPath: URL {
        return documentDirectoryURL.appendingPathComponent(path)
    }
    
    private var documentDirectoryURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
