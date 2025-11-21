# План реализации iOS приложения для лотереи

## 1. Архитектура и технологии

### Технологический стек:
- **Язык**: Swift 5.9+
- **Минимальная версия iOS**: 15.0
- **Архитектура**: MVVM (Model-View-ViewModel)
- **UI Framework**: SwiftUI
- **Навигация**: NavigationStack (iOS 16+) или NavigationView
- **Сетевой слой**: URLSession + async/await
- **JSON парсинг**: Codable
- **Хранение данных**: UserDefaults + Keychain (для токенов)
- **Зависимости**: Swift Package Manager

### Структура проекта:
```
ios/
├── LotteryApp/
│   ├── App/
│   │   ├── LotteryApp.swift (точка входа)
│   │   └── ContentView.swift
│   ├── Models/
│   │   ├── User.swift
│   │   ├── Game.swift
│   │   ├── GameStatusResponse.swift
│   │   ├── ParticipateResponse.swift
│   │   ├── Transaction.swift
│   │   └── AuthModels.swift
│   ├── Services/
│   │   ├── ApiService.swift
│   │   ├── AuthService.swift
│   │   ├── GameService.swift
│   │   ├── UserService.swift
│   │   └── TokenManager.swift
│   ├── ViewModels/
│   │   ├── LoginViewModel.swift
│   │   ├── RegisterViewModel.swift
│   │   ├── HomeViewModel.swift
│   │   └── ProfileViewModel.swift
│   ├── Views/
│   │   ├── Auth/
│   │   │   ├── LoginView.swift
│   │   │   └── RegisterView.swift
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   ├── GameTimerView.swift
│   │   │   └── RulesView.swift
│   │   └── Profile/
│   │       ├── ProfileView.swift
│   │       └── TransactionsView.swift
│   └── Utils/
│       ├── ValidationUtils.swift
│       ├── Constants.swift
│       └── Extensions.swift
└── LotteryApp.xcodeproj
```

## 2. Экраны и функционал

### 2.1. Экран входа (LoginView)
**Функционал:**
- Поля: Email, Password
- Валидация email (формат)
- Валидация пароля (не пустой)
- Кнопка "Войти"
- Переход на регистрацию
- Сохранение токена при успешном входе
- Автоматический переход на HomeView если уже авторизован

**UI компоненты:**
- TextField для email
- SecureField для password
- Button для входа
- NavigationLink для регистрации
- Alert для ошибок

### 2.2. Экран регистрации (RegisterView)
**Функционал:**
- Поля: Email, Password, First Name, Last Name, Middle Name (опционально)
- Валидация:
  - Email: формат email
  - Password: минимум 6 символов, буквы и цифры
  - First Name, Last Name: обязательные
- Checkbox для принятия лицензионного соглашения
- Кнопка "Зарегистрироваться"
- Переход на HomeView при успешной регистрации
- Отображение текста лицензионного соглашения

**UI компоненты:**
- TextField для всех полей
- SecureField для password
- Toggle для согласия
- ScrollView для текста соглашения
- Button для регистрации

### 2.3. Главный экран (HomeView)
**Функционал:**
- Отображение текущей игры:
  - Количество участников (диапазон 95-130)
  - Призовой фонд
  - Стоимость участия (1₽)
  - Таймер обратного отсчета (30 минут)
- Кнопка "Участвовать"
- Кнопка "Правила игры"
- Отображение количества билетов пользователя
- Сообщения о близости к победе
- Автоматическое обновление статуса каждые 5 секунд
- Полная синхронизация каждые 5 минут
- Локальный таймер с обновлением каждую секунду
- Блокировка кнопки при истечении времени

**UI компоненты:**
- VStack для основной информации
- Text для участников, приза
- TimerView для обратного отсчета
- Button для участия
- Button для правил
- Sheet/Alert для модальных окон
- ProgressView для загрузки

### 2.4. Экран профиля (ProfileView)
**Функционал:**
- Отображение информации пользователя:
  - Email
  - Имя, Фамилия, Отчество
  - Баланс
  - Telegram ник (если верифицирован)
- Кнопка "Пополнить счет" (редирект на Telegram группу)
- Кнопка "Транзакции"
- Кнопка "Выйти"
- Редактирование профиля

**UI компоненты:**
- Form для данных пользователя
- List для транзакций
- Button для действий
- Link для Telegram

### 2.5. Экран транзакций (TransactionsView)
**Функционал:**
- Список всех транзакций пользователя
- Отображение: тип, сумма, описание, дата
- Сортировка по дате (новые сверху)

**UI компоненты:**
- List с ForEach
- Custom TransactionRow

### 2.6. Модальное окно правил игры (RulesView)
**Функционал:**
- Отображение правил игры
- Кнопка закрытия

## 3. Сетевой слой

### 3.1. API Service
**Базовый URL**: `http://94.103.9.172:8081/`

**Эндпоинты:**
- `POST /api/register` - регистрация
- `POST /api/login` - вход
- `GET /api/profile` - профиль (требует токен)
- `PUT /api/profile` - обновление профиля
- `GET /api/game/current` - текущая игра
- `POST /api/game/participate` - участие в игре
- `GET /api/transactions` - список транзакций
- `POST /api/transactions/deposit` - пополнение (заблокировано для неверифицированных)

### 3.2. Аутентификация
- JWT токен хранится в Keychain
- Токен добавляется в заголовок `Authorization: Bearer <token>`
- Автоматический logout при 401 ошибке

### 3.3. Обработка ошибок
- Network errors
- Validation errors
- Server errors (400, 401, 402, 500)
- Показ пользователю понятных сообщений

## 4. Локальное хранение данных

### 4.1. UserDefaults
- Флаг авторизации
- Базовая информация пользователя (кэш)

### 4.2. Keychain
- JWT токен (безопасное хранение)
- Использование Keychain Services API

## 5. Таймер игры

### 5.1. Логика таймера
- Получение `time_remaining` и `server_time` с бэкенда
- Локальный расчет оставшегося времени
- Обновление каждую секунду
- Форматирование: MM:SS
- Блокировка участия при истечении времени

### 5.2. Синхронизация
- Каждые 5 секунд: проверка статуса игры
- Каждые 5 минут: полная синхронизация времени

## 6. Валидация

### 6.1. Email
- Регулярное выражение для формата email
- Проверка на пустоту

### 6.2. Password
- Минимум 6 символов
- Должен содержать буквы
- Должен содержать цифры

## 7. UI/UX особенности

### 7.1. Дизайн
- Современный Material Design стиль (адаптированный для iOS)
- Цветовая схема: фиолетовый/синий для основных элементов
- Зеленый для успешных операций
- Красный для ошибок и таймера

### 7.2. Анимации
- Плавные переходы между экранами
- Анимация таймера
- Confetti при победе (если возможно)

### 7.3. Уведомления
- Push уведомления о новой игре (опционально)
- Локальные уведомления

## 8. Особенности iOS

### 8.1. Безопасность
- Keychain для токенов
- App Transport Security настройки (для HTTP)
- Валидация сертификатов

### 8.2. Производительность
- Async/await для сетевых запросов
- Background tasks для синхронизации
- Кэширование данных

### 8.3. Адаптивность
- Поддержка разных размеров экранов
- Dark mode (опционально)
- Поддержка iPad (опционально)

## 9. Зависимости (Swift Package Manager)

- Нет внешних зависимостей (используем нативные API)
- При необходимости: SwiftUI Extensions

## 10. Этапы реализации

### Этап 1: Настройка проекта
1. Создание Xcode проекта
2. Настройка структуры папок
3. Настройка Info.plist (ATS для HTTP)
4. Создание базовых моделей

### Этап 2: Сетевой слой
1. Создание ApiService
2. Реализация TokenManager
3. Создание сервисов для каждого эндпоинта
4. Обработка ошибок

### Этап 3: Аутентификация
1. LoginView + ViewModel
2. RegisterView + ViewModel
3. Валидация
4. Сохранение токена

### Этап 4: Главный экран
1. HomeView + ViewModel
2. Таймер
3. Участие в игре
4. Правила игры

### Этап 5: Профиль
1. ProfileView + ViewModel
2. Редактирование профиля
3. Транзакции
4. Telegram редирект

### Этап 6: Полировка
1. Обработка ошибок
2. Loading states
3. Анимации
4. Тестирование

## 11. Отличия от Android версии

1. **UI Framework**: SwiftUI вместо XML layouts
2. **Архитектура**: MVVM с Combine (опционально) вместо LiveData
3. **Сетевой слой**: URLSession вместо Retrofit
4. **Хранение**: Keychain вместо SharedPreferences для токенов
5. **Навигация**: NavigationStack вместо Navigation Component
6. **Язык**: Swift вместо Kotlin

## 12. Конфигурация

### Info.plist настройки:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### URL для Telegram:
`https://t.me/+N9L_oc7gGlkyZWYx`

## 13. Тестирование

1. Unit тесты для ViewModels
2. Unit тесты для валидации
3. Integration тесты для API
4. UI тесты для основных сценариев

