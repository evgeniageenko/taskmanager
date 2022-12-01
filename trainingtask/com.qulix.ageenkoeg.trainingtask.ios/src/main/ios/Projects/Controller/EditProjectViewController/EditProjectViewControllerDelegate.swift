import Foundation

/**
 Протокол описывает реализацию метода сохранения данных для экрана "Список проектов"
 */
protocol EditProjectViewControllerDelegate: AnyObject {
    
    /**
    Изменить проект
     
     - parameters:
        - model: Проект, который необходимо изменить
     */
    func editAndSaveProject(model: Project)
    
    /**
     Создать проект
     
     - parameters:
        - model: Проект, который необходимо создать
     */
    func createProject(model: EditProjectModel)
}
