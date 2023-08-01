import SwiftUI

struct HabitProgressCell: View {
    
    let model: HabitModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(model.name)
                    .font(Font.title)
                    .ifNeeded(model.progress == 1) {
                        $0.strikethrough()
                    }
                Text(model.motivation)
                    .font(Font.subheadline)
            }
            Spacer()
            ZStack {
                Text("\(Int(model.progress * 100)) %")
                    .padding(16)
                CircularProgressView(
                    progress: model.progress,
                    color: model.color
                )
                .frame(width: 75, height: 75, alignment: .center)
            }
            .padding()
            
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .contentShape(Rectangle())
        .opacity(model.progress == 1 ? 0.3 : 1)
    }
}

struct HabitProgressCell_Previews: PreviewProvider {
    
    @State static var value = true
    
    static var previews: some View {
        HabitProgressCell(
            model: HabitModel(
                name: "Спорт",
                motivation: "Хочу быть красивым и успешным",
                progress: 0.75,
                color: .red,
                habitProgresses: []
            )
        )
    }
}
