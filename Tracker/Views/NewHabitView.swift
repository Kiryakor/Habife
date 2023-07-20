import SwiftUI

struct NewHabitView: View {
        
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var motivation: String = ""
    @State private var color = Color.randomColor()
    
    var addCallback: ((HabitModel) -> Void)?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text("Название")
                            .font(Font.body)
                        TextField("Спорт", text: $name)
                    })
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text("Описание")
                            .font(Font.body)
                        TextField("Не ленись !", text: $motivation)
                    })
                    VStack {
                        ColorPicker(selection: $color) {
                            Text("Выберите цвет")
                                .font(Font.body)
                        }
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
                    .disabled(name.isEmpty || motivation.isEmpty)
                }
            }
        }
    }
}
