import Foundation

/**
 Перечисление возможных результатов проверки валидации на экране "Редактирование сотрудника"
 */
enum EditEmployeeValidationResult {
    
    /**
     Успешная проверка
     
     - parameters:
        - employee: Модель "Сотрудника"
     */
    case success(_ employee: EditEmployeeModel)
    
    /**
     Ошибка при проверке
     
     - parameters:
        - error: Модель "ошибки"
     */
    case error(_ error: AppError)
}
