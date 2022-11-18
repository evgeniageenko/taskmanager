import Foundation

/**
 Протокол описывает реализацию метода сохранения данных для экрана "Список проектов"
 */
protocol EditProjectViewControllerDelegate: AnyObject {
    
    /**
     Сохранить/изменить проект
     
     - parameters:
        - model: Проект, который необходимо сохранить/изменить
        - isOpenFromAddButton: Проверка - был ли произведен переход с помощью кнопки "Добавить"
     */
    func saveProject(model: Project, isOpenFromAddButton: Bool)
}
