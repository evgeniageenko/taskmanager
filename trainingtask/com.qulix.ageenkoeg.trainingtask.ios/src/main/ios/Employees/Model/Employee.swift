import Foundation

/**
 Класс модели "Сотрудник"
 */
class Employee {
    
    /**
     Фамилия сотрудника
     */
    var surName: String
    
    /**
     Имя сотрудника
     */
    var name: String
    
    /**
     Отчество сотрудника
     */
    var middleName: String
    
    /**
     Должность сотрудника
     */
    var position: String
    
    /**
     id сотрудника
     
     Свойство id уникально для каждого сотрудника. Работа с сотрудником (удаление, редактирование) производится используя id.
     */
    let id: UUID?
    
    /**
     Фамилия Имя Отчество сотрудника
     */
    var fullName: String
    
    /**
     Создает нового сотрудника
     
     - parameters:
        - surName: Фамилия
        - name: Имя
        - middleName: Отчество
        - position: Должность
        - id: Идентификатор сотрудника
        - fullName: Фамилия имя отчество сотрудника
     */
    init(surName: String, name: String, middleName: String, position: String, id: UUID?) {
        self.surName = surName
        self.name = name
        self.middleName = middleName
        self.position = position
        self.id = id
        self.fullName = surName + " " + name + " " + middleName
    }
}
