import SwiftUI

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
