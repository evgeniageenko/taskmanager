import Foundation

/**
 Перечисление возможных статусов задачи
 */
enum TaskStatus: String, CaseIterable {
    
    /**
     Не начата
     */
    case notStarted
    
    /**
     В процессе
     */
    case inProgress
    
    /**
     Завершена
     */
    case done
    
    /**
     Отложена
     */
    case postponed
    
    /**
     Получить количество статусов задачи
     
     - returns: Количество статусов "Задачи"
     */
    static func numberOfRow() -> Int {
        return self.allCases.count
    }
    
    /**
     Получить выбранный статус задачи
     - parameters:
        - row: Строка
     
     - returns: Статус  "Задачи"
     */
    static func getItem(_ row: Int) -> TaskStatus {
        return self.allCases[row]
    }
    
    /**
     Локализованный статус задачи
     */
    var localizedStatus: String {
        switch self {
        case .notStarted:
            return NSLocalizedString("Не начата", comment: "")
        case .inProgress:
            return NSLocalizedString("В процессе", comment: "")
        case .done:
            return NSLocalizedString("Завершена", comment: "")
        case .postponed:
            return NSLocalizedString("Отложена", comment: "")
        }
    }
    
    /**
     Создает локализованный статус задачи
     */
    init?(localizedStatus: String) {
        switch localizedStatus {
        case NSLocalizedString("Не начата", comment: ""):
                self = .notStarted
        case NSLocalizedString("В процессе", comment: ""):
                self = .inProgress
        case NSLocalizedString("Завершена", comment: ""):
                self = .done
        case NSLocalizedString("Отложена", comment: ""):
                self = .postponed
        default:
            return nil
        }
    }
}
