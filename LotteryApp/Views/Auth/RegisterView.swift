import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showAgreement = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Регистрация")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Email *")
                            .font(.headline)
                        TextField("Введите email", text: $viewModel.email)
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Пароль *")
                            .font(.headline)
                        SecureField("Введите пароль", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Имя *")
                            .font(.headline)
                        TextField("Введите имя", text: $viewModel.firstName)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Фамилия *")
                            .font(.headline)
                        TextField("Введите фамилию", text: $viewModel.lastName)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Отчество")
                            .font(.headline)
                        TextField("Введите отчество", text: $viewModel.middleName)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Условия участия:")
                            .font(.headline)
                        
                        ScrollView {
                            Text(agreementText)
                                .font(.caption)
                                .padding(8)
                                .frame(maxHeight: 120)
                        }
                        .border(Color.gray.opacity(0.3), width: 1)
                        
                        Toggle("Я согласен с условиями использования", isOn: $viewModel.agreedToTerms)
                    }
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.register()
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        } else {
                            Text("Зарегистрироваться")
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isLoading || !viewModel.agreedToTerms)
                }
                .padding()
            }
            .navigationTitle("Регистрация")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.isRegistered) {
                HomeView()
            }
        }
    }
    
    private let agreementText = """
    ЛИЦЕНЗИОННОЕ СОГЛАШЕНИЕ

    1. ОБЩИЕ ПОЛОЖЕНИЯ

    1.1. Настоящее Лицензионное соглашение (далее - «Соглашение») определяет условия использования мобильного приложения «Лотерея» (далее - «Приложение»).

    1.2. Используя Приложение, Пользователь принимает условия настоящего Соглашения в полном объеме.

    1.3. Администрация оставляет за собой право изменять условия Соглашения без уведомления Пользователя.

    2. ПРАВА И ОБЯЗАННОСТИ ПОЛЬЗОВАТЕЛЯ

    2.1. Пользователь обязуется использовать Приложение только в законных целях.

    2.2. Пользователь несет ответственность за сохранность своих учетных данных.

    2.3. Пользователь обязуется не передавать свои учетные данные третьим лицам.

    3. УЧАСТИЕ В ЛОТЕРЕЕ

    3.1. Участие в лотерее осуществляется путем внесения платы за участие.

    3.2. Победитель определяется случайным образом в соответствии с правилами игры.

    3.3. Администрация не гарантирует выигрыш.

    4. ОТВЕТСТВЕННОСТЬ

    4.1. Администрация не несет ответственности за убытки, возникшие в результате использования Приложения.

    4.2. Пользователь несет полную ответственность за свои действия в Приложении.

    5. КОНФИДЕНЦИАЛЬНОСТЬ

    5.1. Администрация обязуется защищать персональные данные Пользователя в соответствии с законодательством.

    5.2. Персональные данные используются исключительно для предоставления услуг Приложения.

    6. ЗАКЛЮЧИТЕЛЬНЫЕ ПОЛОЖЕНИЯ

    6.1. Настоящее Соглашение вступает в силу с момента начала использования Приложения.

    6.2. Все споры решаются путем переговоров, а при невозможности достижения соглашения - в судебном порядке.
    """
}

