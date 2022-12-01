import Foundation

/**
 Cтруктура модели "Задачи"
 */
struct Task {
    
    /**
     Название задачи
     */
    let name: String
        
    /**
     id проекта, к которому относится задача
     */
    let projectId: UUID
    
    /**
     Количество времени, необходимое для выполнения задачи
     */
    let timeToComplete: Int
    
    /**
     Дата начала задачи
     */
    let startDate: Date
    
    /**
     Дата окончания задачи
     */
    let endDate: Date
    
    /**
     Статус задачи
     */
    let status: TaskStatus
    
    /**
     id исполнителя задачи
     */
    let employeeId: UUID?
    
    /**
     id задачи
     
     Свойство id уникально для каждой задачи.
     */
    let id: UUID
    
    /**
     Создает новую задачу
     
     - parameters:
        - name: Название задачи
        - projectId: id проекта, к которому относится задача
        - timeToComplete: Количество времени, необходимое для выполнения задачи
        - startDate: Дата начала задачи
        - endDate: Дата окочнания задачи
        - status: Статус задачи
        - employeeId: id исполнителя задачи
        - id: id задачи
     */
    init(name: String,
         projectId: UUID,
         timeToComplete: Int,
         startDate: Date,
         endDate: Date,
         status: TaskStatus,
         employeeId: UUID? = nil,
         id: UUID) {
        self.name = name
        self.projectId = projectId
        self.timeToComplete = timeToComplete
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.employeeId = employeeId
        self.id = id
    }
}
