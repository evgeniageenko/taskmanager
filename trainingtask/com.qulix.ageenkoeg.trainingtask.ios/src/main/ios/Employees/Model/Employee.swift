import Foundation

/**
 Структура модели "Сотрудник"
 */
struct Employee {
    
    /**
     Фамилия сотрудника
     */
    let surName: String
    
    /**
     Имя сотрудника
     */
    let name: String
    
    /**
     Отчество сотрудника
     */
    let middleName: String
    
    /**
     Должность сотрудника
     */
    let position: String
    
    /**
     id сотрудника
     
     Свойство id уникально для каждого сотрудника.
     */
    let id: UUID
    
    /**
     Фамилия имя отчество сотрудника
     */
    let fullName: String
    
    /**
     Создает нового сотрудника
     
     - parameters:
        - surName: Фамилия
        - name: Имя
        - middleName: Отчество
        - position: Должность
        - id: id сотрудника
        - fullName: Фамилия имя отчество сотрудника
     */
    init(surName: String, name: String, middleName: String, position: String, id: UUID) {
        self.surName = surName
        self.name = name
        self.middleName = middleName
        self.position = position
        self.id = id
        self.fullName = surName + " " + name + " " + middleName
    }
}
