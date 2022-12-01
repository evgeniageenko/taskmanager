import Foundation

/**
 Перечисление возможных результатов проверки валидации на экране "Настройки"
 */
enum SettingsValidationResult {
    
    /**
     Успешная проверка
     
     - parameters:
        - settings: Модель "Настройки"
     */
    case success(_ settings: Settings)
    
    /**
     Ошибка при проверке
     
     - parameters:
        - error: Модель "ошибки"
     */
    case error(_ error: AppError)
}
