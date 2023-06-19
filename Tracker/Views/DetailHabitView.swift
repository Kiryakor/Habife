import SwiftUI

struct DetailHabitView: View {
    
    let model: HabitModel
    
    var body: some View {
        Text(model.name)
    }
}
