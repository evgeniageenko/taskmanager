import Foundation

/**
 Протокол описывает реализацию метода сохранения данных для экрана "Список задач"
 */
protocol EditTaskViewControllerDelegate: AnyObject {
    
    /**
     Изменить задачу
     
     - parameters:
        - model: Задача, которую необходимо изменить
     */
    func editAndSaveTask(model: Task)
    
    /**
     Создать задачу
     
     - parameters:
        - model: Задача, которую необходимо создать
     */
    func createTask(model: EditTaskModel)

}
