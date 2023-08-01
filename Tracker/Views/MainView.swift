import SwiftUI

// MARK: - MainView

struct MainView: View {
    
    @State private var models: [HabitModel] = []
    
    @State private var showingNewHabit = false
    
    private var habitRepository: HabitRepositoryProtocol
    
    init(with habitRepositoriy: HabitRepositoryProtocol) {
        self.habitRepository = habitRepositoriy
        
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(models, id: \.self) { model in
                    Section {
                        NavigationLink {
                            DetailHabitView(model: model)
                        } label: {
                            HabitProgressCell(model: model)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete") {
                            delete(at: model)
                        }
                        .tint(.red)
                    }
                    .ifNeeded(model.progress != 1) {
                        $0.swipeActions(edge: .leading) {
                            Button("Order") {
                                updateProgress(for: model)
                            }
                            .tint(.green)
                        }
                    }
                }
            }
            .navigationTitle("Habife")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingNewHabit = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary)
                    }
                }
            }
            .sheet(isPresented: $showingNewHabit) {
                NewHabitView(isPresented: $showingNewHabit) { model in
                    models.insert(model, at: 0)
                    saveModels()
                }
            }
        }
        .task {
            var models = await habitRepository.getHabits()

            models.sort { lhs, rhs in
                if lhs.progress == 1 {
                    return false
                }
                if rhs.progress == 1 {
                    return true
                }
                return true
            }
            self.models = models
        }
    }
    
    // MARK: - Private
    
    private func updateProgress(for model: HabitModel) {
        guard let index = models.firstIndex(of: model) else { return }
        
        var progress = model.progress + 0.1
        if progress > 1 {
            progress = 1
        }
        
        models[index].progress = progress
        
        saveModels()
    }
    
    private func delete(at model: HabitModel) {
        guard let index = models.firstIndex(of: model) else { return }
            
        models.remove(at: index)
        saveModels()
    }
    
    private func saveModels() {
        // надо бы diff считать, а не на каждый чих все перезаписывать
        habitRepository.save(models)
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    
    @State static var value = true
    
    static var previews: some View {
        MainView(with: HabitRepositoryMock())
    }
}
