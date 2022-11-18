import Foundation

/**
 Протокол описывает реализацию метода сохранения данных для экрана "Список задач"
 */
protocol EditTaskViewControllerDelegate: AnyObject {
    
    /**
     Сохранить/изменить задачу
     
     - parameters:
        - model: Задача, которую необходимо сохранить/изменить
        - isOpenFromAddButton: Проверка - был ли произведен переход с помощью кнопки "Добавить"
     */
    func saveTask(model: Task, isOpenFromAddButton: Bool)
}
