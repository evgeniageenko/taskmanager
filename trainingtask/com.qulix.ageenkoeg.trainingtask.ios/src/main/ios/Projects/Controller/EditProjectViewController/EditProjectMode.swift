import Foundation

/**
 Перечисление возможных действий на экране "Редактирование проекта"
 */
enum EditProjectMode {
    
    /**
     Создать проект
     */
    case create
    
    /**
     Редактировать проект
     
     - parameters:
        - project: Модель проекта
     */
    case edit(project: Project)
}
