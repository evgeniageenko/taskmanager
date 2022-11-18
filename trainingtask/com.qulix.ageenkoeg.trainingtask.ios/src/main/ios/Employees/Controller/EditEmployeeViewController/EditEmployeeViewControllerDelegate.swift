import Foundation

/**
 Протокол описывает реализацию метода сохранения данных для экрана "Список сотрудников"
 */
protocol EditEmployeeViewControllerDelegate: AnyObject {
    
    /**
     Сохранить/изменить проект
     
     - parameters:
        - model: Сотрудник, которого необходимо сохранить/изменить
        - isOpenFromAddButton: Проверка - был ли произведен переход с помощью кнопки "Добавить"
     */
    func saveEmployee(model: Employee, isOpenFromAddButton: Bool)
}
