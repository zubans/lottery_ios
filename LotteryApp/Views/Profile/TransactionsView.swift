import SwiftUI

struct TransactionsView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.transactions.isEmpty {
                    Text("Нет транзакций")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(viewModel.transactions, id: \.id) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
            }
            .navigationTitle("Транзакции")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.loadTransactions()
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(transaction.type == "credit" ? "Пополнение" : transaction.type == "debit" ? "Списание" : transaction.type)
                    .font(.headline)
                Spacer()
                Text("\(transaction.type == "credit" ? "+" : "-")\(String(format: "%.2f", transaction.amount)) ₽")
                    .fontWeight(.bold)
                    .foregroundColor(transaction.type == "credit" ? .green : .red)
            }
            
            if let description = transaction.description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(formatDate(transaction.createdAt))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            displayFormatter.locale = Locale(identifier: "ru_RU")
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
}

