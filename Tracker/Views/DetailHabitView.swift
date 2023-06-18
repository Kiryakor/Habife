import SwiftUI

struct DetailHabitView: View {
    
    @Binding var isPresented: Bool
    
    let model: HabitModel
    
    var body: some View {
        Text(model.name)
    }
}
