import Foundation

/**
 Структура модели "Проекта"
 */
struct Project {
    
    /**
     Название проекта
     */
    let name: String
    
    /**
     Описание проекта
     */
    let description: String
    
    /**
     id проекта
     
     Свойство id уникально для каждого проекта.
     */
    let id: UUID
    
    /**
     Создает новый проект
     
     - parameters:
        - name: Название проекта
        - description: Описание проекта
        - id: id проекта
     */
    init(name: String, description: String, id: UUID) {
        self.name = name
        self.description = description
        self.id = id
    }
}
