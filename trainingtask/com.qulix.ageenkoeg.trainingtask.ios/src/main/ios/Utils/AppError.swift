import Foundation

/**
 Структура ошибки
 */
struct AppError: Error, LocalizedError {
    
    /**
     Описание ошибки
     */
    let errorDescription: String?
    
    /**
     Создает описание ошибки
     */
    init(message: String) {
        self.errorDescription = message
    }
}
