import SwiftUI

struct HabitProgressCell: View {
    
    let model: HabitModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(model.name)
                    .font(Font.title)
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

struct CircularProgressView: View {
    let progress: Double // from 0 to 1
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.5),
                    lineWidth: 10
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}
