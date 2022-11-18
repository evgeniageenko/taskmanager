import Foundation

/**
 Перечисление пунктов меню приложения
 */
enum MenuItem: String, CaseIterable {
    
    /**
     Проекты
     */
    case projects
    
    /**
     Задачи
     */
    case tasks
    
    /**
     Сотрудники
     */
    case emoloyees
    
    /**
     Настройки
     */
    case settings 
    
    /**
     Получить количество строк Меню
     
     - returns: Количество строк меню для экрана "MenuViewController"
     */
    static func numberOfRow() -> Int {
        return self.allCases.count
    }
    
    /**
     Получить пункт меню
     - parameters:
        - row: Строка
     
     - returns: Пункт меню для экрана "MenuViewController"
     */
    static func getItem(_ row: Int) -> MenuItem {
        return self.allCases[row]
    }
}

