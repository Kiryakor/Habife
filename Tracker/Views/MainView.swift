import SwiftUI

// MARK: - MainView

struct MainView: View {
    
    @State private var models: [HabitModel] = []
    
    @State private var showingNewHabit = false
    @State private var showingDetailHabit = false
    
    @State private var detailModel: HabitModel? = nil
    
    private var habitRepository: HabitRepositoryProtocol
    
    init(with habitRepositoriy: HabitRepositoryProtocol) {
        self.habitRepository = habitRepositoriy
        
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(Array(models.enumerated()), id: \.offset) { index, model in
                        HabitProgressCell(model: model)
                            .onTapGesture(perform: {
                                detailModel = model
                                showingDetailHabit = true
                            })
                            .onLongPressGesture{
                                print("longPressed")
                            }
                    }
                    .onDelete(perform: delete(at:))
                }
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
                    habitRepository.save(models) // test
                }
            }
            .sheet(isPresented: $showingDetailHabit,
                   onDismiss: { detailModel = nil },
                   content: {
                DetailHabitView(
                    isPresented: $showingDetailHabit,
                    model: detailModel!
                )
            })
        }
        .task {
            models = await habitRepository.getHabits()
        }
    }
    
    private func delete(at offsets: IndexSet) {
        models.remove(atOffsets: offsets)
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    
    @State static var value = true
    
    static var previews: some View {
        MainView(with: HabitRepositoryMock())
    }
}
