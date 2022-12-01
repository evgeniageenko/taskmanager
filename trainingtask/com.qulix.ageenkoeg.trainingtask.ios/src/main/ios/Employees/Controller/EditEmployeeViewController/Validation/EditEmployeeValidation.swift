import Foundation

/**
 Структура валидации на экране "Редактирование сотрудника"
 */
struct EditEmployeeValidation {
    
    /**
     Проверить валидность введенных данных на экране "Редактирование сотрудника"
     
     - parameters:
        - surName: Фамилия сотрудника
        - name: Имя сотрудника
        - middleName: Отчество сотрудника
        - position: Должность сотрудника
     
     - returns: Результат проверки
     */
    func validateAndReturnResult(surName: String?, name: String?, middleName: String?, position: String?) -> EditEmployeeValidationResult {
        guard let surName = surName, !surName.isEmpty else {
            let error = "Введите фамилию"
            return .error(AppError(message: error))
        }
        
        guard let name = name, !name.isEmpty else {
            let error = "Введите имя"
            return .error(AppError(message: error))
        }
        
        guard let middleName = middleName, !middleName.isEmpty else {
            let error = "Введите отчество"
            return .error(AppError(message: error))
        }
        
        guard let position = position, !position.isEmpty else {
            let error = "Укажите должность"
            return .error(AppError(message: error))
        }
        
        let employee = EditEmployeeModel(
            surName: surName,
            name: name,
            middleName: middleName,
            position: position)
        
        return .success(employee)
    }
}
