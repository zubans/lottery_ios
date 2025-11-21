# GitHub Actions для iOS

## Настройка автоматической сборки

GitHub Actions настроены для автоматической проверки iOS приложения при каждом коммите.

## Workflows

### 1. iOS Build (`ios-build.yml`)
- Запускается при изменении файлов в `ios/`
- Проверяет структуру проекта
- Валидирует Swift файлы
- Собирает проект (если есть Xcode project)

### 2. iOS Tests (`ios-test.yml`)
- Проверяет структуру проекта
- Валидирует наличие всех необходимых файлов

## Требования

Для полной сборки iOS приложения необходимо:

1. **Создать Xcode проект** вручную:
   - Откройте Xcode
   - File → New → Project
   - iOS → App
   - Сохраните в `ios/LotteryApp.xcodeproj`

2. **Или использовать xcodegen**:
   ```bash
   brew install xcodegen
   cd ios
   xcodegen generate
   ```

## Что делает GitHub Actions

✅ Проверяет наличие всех файлов  
✅ Валидирует синтаксис Swift  
✅ Проверяет структуру проекта  
⚠️ Полная сборка требует Xcode project файл

## Ограничения

- GitHub Actions не может создать `.xcodeproj` файл автоматически
- Для создания IPA нужны сертификаты подписи
- Тесты требуют Xcode project

## Рекомендации

1. Создайте Xcode проект локально на Mac
2. Закоммитьте `.xcodeproj` файл (или используйте xcodegen)
3. GitHub Actions будет автоматически собирать проект

## Альтернатива: xcodegen

Если нет доступа к Mac, можно использовать xcodegen для генерации проекта из YAML:

```bash
# Установка xcodegen (на Mac или через Docker)
brew install xcodegen

# Генерация проекта
cd ios
xcodegen generate
```

Файл `xcodegen.yml` уже создан в проекте.

