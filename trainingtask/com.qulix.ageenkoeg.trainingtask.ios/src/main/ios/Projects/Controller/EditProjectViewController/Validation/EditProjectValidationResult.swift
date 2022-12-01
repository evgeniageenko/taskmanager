import Foundation

/**
 Перечисление возможных результатов проверки валидации на экране "Редактирование проекта"
 */
enum EditProjectValidationResult {
    
    /**
     Успешная проверка
     
     - parameters:
        - project: Модель "Проекта"
     */
    case success(_ project: EditProjectModel)
    
    /**
     Ошибка при проверке
     
     - parameters:
        - error: Модель "ошибки"
     */
    case error(_ error: AppError)
}
