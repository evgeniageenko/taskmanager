import Foundation

/**
 Перечисление возможных результатов проверки валидации на экране "Редактирование задачи"
 */
enum EditTaskValidationResult {
    
    /**
     Успешная проверка
     
     - parameters:
        - task: Модель "Задачи"
     */
    case success(_ task: EditTaskModel)
    
    /**
     Ошибка при проверке
     
     - parameters:
        - error: Модель "ошибки"
     */
    case error(_ error: AppError)
}
