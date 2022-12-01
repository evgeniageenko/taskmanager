import Foundation

/**
 Данная структура предназначена для создания/конвертации "Статуса" задачи
 */
struct TaskStatusBuilder {
    
    /**
     Создать "Статус" задачи из строки
     
     - parameters:
        - from: Строка, которую нужно перевести в "Статус"
     
     - returns: "Статус" задачи
     */
    func build(from string: String) -> TaskStatus? {
        switch string {
        case "Не начата":
            return .notStarted
        case "В процессе":
            return .inProgress
        case "Завершена":
            return .done
        case "Отложена":
            return .postponed
        default:
            return nil
        }
    }
    
    /**
     Перевести "Статус" задачи в строку
     
     - parameters:
        - from: "Статус", который нужно перевести в строку
     
     - returns: "Статус" задачи в виде строки
     */
    func string(from status: TaskStatus) -> String {
        switch status {
        case .notStarted:
            return "Не начата"
        case .inProgress:
            return "В процессе"
        case .done:
            return "Завершена"
        case .postponed:
            return "Отложена"
        }
    }
}
