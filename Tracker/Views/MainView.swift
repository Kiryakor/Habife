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
                }
                .onDelete(perform: delete(at:))
            }
            .navigationTitle("Habife")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingNewHabit = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color.black)
                    }
                }
            }
            .sheet(isPresented: $showingNewHabit) {
                NewHabitView(isPresented: $showingNewHabit) { model in
                    models.append(model)
                    saveModels()
                }
            }
        }
        .task {
            models = await habitRepository.getHabits()
        }
    }
    
    private func delete(at offsets: IndexSet) {
        models.remove(atOffsets: offsets)
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
