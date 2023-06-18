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
                ForEach(models, id: \.self) { model in
                    Section {
                        HabitProgressCell(model: model)
                            .onTapGesture(perform: {
                                detailModel = model
                                showingDetailHabit = true
                            })
                            .onLongPressGesture{
                                print("longPressed")
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

// MARK: - DetailHabitView

struct DetailHabitView: View {
    
    @Binding var isPresented: Bool
    
    let model: HabitModel
    
    var body: some View {
        Text(model.name)
    }
}

// MARK: - NewHabitView

struct NewHabitView: View {
        
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var motivation: String = ""
    @State private var color = Color.red
    
    var addCallback: ((HabitModel) -> Void)?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text("Название")
                        TextField("Спорт", text: $name)
                    })
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text("Мотивация")
                        TextField("Не ленись !", text: $motivation)
                    })
                    VStack {
                        ColorPicker("Выберите цвет", selection: $color)
                    }
                }
            }
            .navigationTitle("Создать привычку")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отменить") {
                        self.isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.addCallback?(
                            HabitModel(name: name, motivation: motivation, progress: 0, color: color)
                        )
                        self.isPresented = false
                    } label: {
                        Text("Сохранить")
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

// MARK: - HabitProgressCell

struct HabitProgressCell: View {
    
    let model: HabitModel
    
    var body: some View {
        HStack {
            if let color = model.color {
                color
                    .frame(width: 8, height: .infinity, alignment: .center)
                    .cornerRadius(4)
            }
            VStack(alignment: .leading, spacing: 4, content: {
                HStack {
                    Text("\(model.progress) %")
                    Spacer()
                    HStack(spacing: 4) {
                        Text("॰")
                        Text("✓")
                        Text("॰")
                        Text("॰")
                        Text("✓")
                        Text("✓")
                        Text("॰")
                    }
                }
                Text(model.name)
            })
            Spacer()
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .contentShape(Rectangle())
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    
    @State static var value = true
    
    static var previews: some View {
//        NewHabitView(isPresented: $value)
        MainView(with: HabitRepositoryMock(with: DocumentsStorage<HabitModel>()))
    }
}
