import Foundation

/**
 Перечисление возможных действий на экране "Редактирование сотрудника"
 */
enum EditEmployeeMode {

    /**
     Создать сотрудника
     */
    case create
    
    /**
     Редактировать сотрудника
     
     - parameters:
        - employee: Модель сотрудника
     */
    case edit(employee: Employee)
}
