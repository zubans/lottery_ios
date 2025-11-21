import SwiftUI

struct RulesView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    rulesSection(title: "1. Участие в игре", content: "Для участия необходимо приобрести билет стоимостью 1 рубль. Каждый билет дает вам шанс выиграть приз.")
                    
                    rulesSection(title: "2. Длительность игры", content: "Каждая игра длится 30 минут с момента покупки первого билета.")
                    
                    rulesSection(title: "3. Определение победителя", content: "Победителем становится участник, купивший билет с номером, равным целевому количеству участников. Если время истекло, а целевое количество не достигнуто, приз получает владелец последнего билета.")
                    
                    rulesSection(title: "4. Новая игра", content: "После завершения игры новая игра начинается только после покупки хотя бы одного билета.")
                    
                    rulesSection(title: "5. Призовой фонд", content: "Призовой фонд формируется из стоимости всех купленных билетов и составляет 100 рублей.")
                }
                .padding()
            }
            .navigationTitle("Правила игры")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func rulesSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

