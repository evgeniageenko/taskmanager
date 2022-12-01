import Foundation

/**
 Протокол описывает реализацию метода сохранения данных для экрана "Список сотрудников"
 */
protocol EditEmployeeViewControllerDelegate: AnyObject {
    
    /**
     Изменить проект
     
     - parameters:
        - model: Сотрудник, которого необходимо изменить
     */
    func editAndSaveEmployee(model: Employee)
    
    /**
     Создать проект
     
     - parameters:
        - model: Сотрудник, которого необходимо создать
     */
    func createEmployee(model: EditEmployeeModel)
}
