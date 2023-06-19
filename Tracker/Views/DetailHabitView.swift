import SwiftUI
import Charts

struct DetailHabitView: View {
    
    let model: HabitModel
    
    @State private var favoriteColor = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("What is your favorite color?",
                       selection: $favoriteColor) {
                    Text("Неделя").tag(0)
                    Text("Месяц").tag(1)
                    Text("Год").tag(2)
                }.pickerStyle(.segmented)
                
                ChartView()
            }
            .navigationTitle(model.name)
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
    }
}

struct ChartView: View {
    
    var body: some View {
        HStack {
            VStack {
                AxisLabels(.vertical, data: (-10...10).reversed(), id: \.self) {
                    Text("\($0 * 10)")
                        .fontWeight(.bold)
                        .font(Font.system(size: 8))
                        .foregroundColor(.secondary)
                }
                .frame(width: 20)
                
                Rectangle().foregroundColor(.clear).frame(width: 20, height: 20)
            }
            VStack {
                Chart(data: [0.1, 0.3, 0.2, 0.5, 0.4, 0.9, 1])
                    .chartStyle(
                        ColumnChartStyle(
                            column: Rectangle().foregroundColor(.green),
                            spacing: 4
                        )
                    )
                    .padding()
                    .background(
                        GridPattern(
                            horizontalLines: 20 + 1,
                            verticalLines: [0.1, 0.3, 0.2, 0.5, 0.4, 0.9, 1].count + 1
                        )
                        .inset(by: 1)
                        .stroke(Color.gray.opacity(0.1), style: .init(lineWidth: 2, lineCap: .round))
                    )
                AxisLabels(.horizontal, data: 2010...2020, id: \.self) {
                    Text("\($0)".replacingOccurrences(of: ",", with: ""))
                        .fontWeight(.bold)
                        .font(Font.system(size: 8))
                        .foregroundColor(.secondary)
                }
                .frame(height: 20)
                .padding(.horizontal, 1)
            }
        }
    }
}

// MARK: - Previews

struct DetailHabitView_Previews: PreviewProvider {
    
    private static let mockModel = HabitModel(
        name: "Спортч",
        motivation: "Спорт это жизнь",
        progress: 75,
        color: .blue,
        habitProgresses: []
    )
    
    static var previews: some View {
        DetailHabitView(model: mockModel)
    }
}
