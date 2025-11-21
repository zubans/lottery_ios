# Настройка iOS проекта

## Создание проекта в Xcode

1. Откройте Xcode
2. File → New → Project
3. Выберите "iOS" → "App"
4. Заполните:
   - Product Name: `LotteryApp`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Storage: `None`
5. Сохраните проект в папку `ios/`

## Перенос файлов

После создания проекта, переместите все файлы из `ios/LotteryApp/` в созданный проект Xcode:

1. В Xcode: File → Add Files to "LotteryApp"...
2. Выберите папку `LotteryApp/`
3. Убедитесь, что выбрано:
   - ✅ Copy items if needed
   - ✅ Create groups
   - ✅ Add to targets: LotteryApp

## Настройка Info.plist

1. Откройте `Info.plist` в Xcode
2. Добавьте настройки для HTTP (если еще не добавлены):
   - Key: `App Transport Security Settings`
   - Type: Dictionary
   - Добавьте: `Allow Arbitrary Loads` = `YES`

Или используйте готовый `Info.plist` из проекта.

## Настройка Signing

1. Выберите проект в навигаторе
2. Выберите Target "LotteryApp"
3. Перейдите в "Signing & Capabilities"
4. Выберите вашу Team
5. Xcode автоматически создаст Provisioning Profile

## Запуск

1. Выберите симулятор или подключенное устройство
2. Нажмите Run (⌘R)

## Структура файлов в Xcode

Убедитесь, что структура соответствует:

```
LotteryApp
├── App
│   ├── LotteryApp.swift
│   └── ContentView.swift
├── Models
│   ├── User.swift
│   ├── Game.swift
│   ├── AuthModels.swift
│   └── Transaction.swift
├── Services
│   ├── ApiService.swift
│   ├── AuthService.swift
│   ├── GameService.swift
│   ├── UserService.swift
│   └── TokenManager.swift
├── ViewModels
│   ├── LoginViewModel.swift
│   ├── RegisterViewModel.swift
│   ├── HomeViewModel.swift
│   └── ProfileViewModel.swift
├── Views
│   ├── Auth
│   │   ├── LoginView.swift
│   │   └── RegisterView.swift
│   ├── Home
│   │   ├── HomeView.swift
│   │   └── RulesView.swift
│   └── Profile
│       ├── ProfileView.swift
│       └── TransactionsView.swift
└── Utils
    ├── Constants.swift
    ├── ValidationUtils.swift
    └── Extensions.swift
```

## Тестирование

1. Запустите приложение на симуляторе
2. Проверьте регистрацию и вход
3. Проверьте участие в игре
4. Проверьте таймер
5. Проверьте профиль и транзакции

## Возможные проблемы

### Ошибка компиляции "Cannot find type"
- Убедитесь, что все файлы добавлены в Target "LotteryApp"
- Проверьте, что все импорты правильные

### Ошибка сети
- Проверьте настройки App Transport Security в Info.plist
- Убедитесь, что бэкенд доступен по указанному адресу

### Ошибка Keychain
- Убедитесь, что включен Keychain Sharing capability (если требуется)

