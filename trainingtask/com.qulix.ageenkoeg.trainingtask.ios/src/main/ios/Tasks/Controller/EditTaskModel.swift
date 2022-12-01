import Foundation

/**
 Данная структура является моделью "Редактирования задачи"
 */
struct EditTaskModel {
    
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
}
