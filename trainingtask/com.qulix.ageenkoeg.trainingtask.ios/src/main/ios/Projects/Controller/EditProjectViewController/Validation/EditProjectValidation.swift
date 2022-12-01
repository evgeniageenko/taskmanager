import Foundation

/**
 Структура валидации на экране "Редактирование проекта"
 */
struct EditProjectValidation {
    
    /**
     Проверить валидность введенных данных на экране "Редактирование проекта"
     
     - parameters:
        - name: Название проекта
        - descripion: Описание проекта
     
     - returns: Результат проверки
     */
    func validateAndReturnResult(name: String?, descripion: String?) -> EditProjectValidationResult {
        guard let name = name, !name.isEmpty else {
            let error = "Введите наименование"
            return .error(AppError(message: error))
        }
        
        guard let descripion = descripion, !descripion.isEmpty else {
            let error = "Введите описание"
            return .error(AppError(message: error))
        }
        
        let project = EditProjectModel(
            name: name,
            description: descripion)
        
        return .success(project)
    }
}
