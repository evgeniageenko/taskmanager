import Foundation

/**
 Класс модели "Задачи"
 */
class Task {
    
    /**
     Название задачи
     */
    var name: String
    
    /**
     Название проекта, к которому относится задача
     */
    var project: String
    
    /**
     id проекта, к которому относится задача
     */
    var projectId: UUID?
    
    /**
     Количество времени, необходимое для выполнения задачи
     */
    var timeToComplete: Int
    
    /**
     Дата начала задачи
     */
    var startDate: Date
    
    /**
     Дата окончания задачи
     */
    var endDate: Date
    
    /**
     Статус задачи
     */
    var status: TaskStatus
    
    /**
     Исполнитель задачи
     */
    var employeeName: String?
    
    /**
     id исполнителя задачи
     */
    var employeeId: UUID?
    
    /**
     id задачи
     
     Свойство id уникально для каждой задачи. Работа с задачей (удаление, редактирование) производится используя id.
     */
    let id: UUID?
    
    /**
     Создает новую задачу
     
     - parameters:
        - name: Название задачи
        - project: Назване проекта
        - projectId: id проекта, к которому относится задача
        - timeToComplete: Количество времени, необходимое для выполнения задачи
        - startDate: Дата начала задачи
        - endDate: Дата окочнания задачи
        - status: Статус
        - employeeName: Исполнитель задачи
        - employeeId: id исполнителя задачи
        - id: Идентификатор задачи
     */
    init(name: String,
         project: String,
         projectId: UUID?,
         timeToComplete: Int,
         startDate: Date,
         endDate: Date,
         status: TaskStatus,
         employeeName: String?,
         employeeId: UUID?,
         id: UUID?) {
        self.name = name
        self.project = project
        self.projectId = projectId
        self.timeToComplete = timeToComplete
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.employeeName = employeeName
        self.employeeId = employeeId
        self.id = id
    }
}
