import Foundation

/**
 Cтруктура модели описания "Задачи"
 */
struct TaskDetailModel {
    
    /**
     Задача
     */
    let task: Task
    
    /**
     Проект, который относится к задаче
     */
    let project: Project
    
    /**
     Сотрудник, который относится к задаче
     
     Задача может существовать без сотрудника
     */
    let employee: Employee?
}
