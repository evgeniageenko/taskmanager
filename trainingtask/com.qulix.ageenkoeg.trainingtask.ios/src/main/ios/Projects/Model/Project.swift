import Foundation

/**
 Класс модели "Проекта"
 */
class Project {
    
    /**
     Название проекта
     */
    var name: String
    
    /**
     Описание проекта
     */
    var description: String
    
    /**
     Массив задач, которые относятся к проекту
     */
    var tasks: [Task]?
    
    /**
     Идентификатор проекта
     
     Свойство id уникально для каждого проекта. Работа с проектом (удаление, редактирвоание) производится используя id.
     */
    let id: UUID?
    
    /**
     Создает новый проект
     
     - parameters:
        - name: Название проекта
        - description: Описание проекта
        - tasks: Массив задач, которые относятся к проекту
        - id: Идентификатор проекта
     */
    init(name: String, description: String, tasks: [Task]?, id: UUID?) {
        self.name = name
        self.description = description
        self.tasks = tasks
        self.id = id
    }
}
