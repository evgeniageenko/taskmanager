import Foundation

/**
 Структура валидации на экране "Настройки"
 */
struct SettingsValidation {
    
    /**
     Проверить валидность введенных данных на экране "Настройки"
     
     - parameters:
        - url: url
        - maxNumOfEntries: Максимальное количество записей в списках
        - numOfDaysBetweenDates: Количество дней по умолчанию между начальной и конечной датами в задаче
     
     - returns: Результат проверки
     */
    func validateAndReturnResult(url: String?, maxNumOfEntries: String?, numOfDaysBetweenDates: String?) -> SettingsValidationResult {
        
        guard let url = url, let urlValue = URL(string: url) else {
            let error = "Некорректный формат URL"
            return .error(AppError(message: error))
        }
        
        guard let maxNumOfEntries, let maxNumOfEntriesValue = Int(maxNumOfEntries) else {
            let error = "Некорректный формат максимального количества записей"
            return .error(AppError(message: error))
        }
        
        guard let numOfDaysBetweenDates, let numOfDaysBetweenDatesValue = Int(numOfDaysBetweenDates) else {
            let error = "Некорректный формат количества дней по умолчанию"
            return .error(AppError(message: error))
        }
        
        let settings = Settings(
            url: urlValue,
            maxNumOfEntries: maxNumOfEntriesValue,
            numOfDaysBetweenDates: numOfDaysBetweenDatesValue)
        
        return .success(settings)
    }
}
