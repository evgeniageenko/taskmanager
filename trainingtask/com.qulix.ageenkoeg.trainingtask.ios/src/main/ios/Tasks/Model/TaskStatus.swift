import Foundation

/**
 Перечисление возможных "Статусов" задачи
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
}
