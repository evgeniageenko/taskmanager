import Foundation

/**
 Интерфейс взаимодействия с сервером
 
 Данный протокол описывает методы работы сервера.
 */
protocol Server {
    
    /**
     Получить проекты
     
     - parameters:
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getProjects(completion: @escaping ([Project]) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Получить задачи
     
     - parameters:
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getTasks(completion: @escaping ([TaskDetailModel]) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Получить сотрудников
     
     - parameters:
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getEmployees(completion: @escaping ([Employee]) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Получить задачи проекта
     
     - parameters:
        - id: Идентификатор проекта
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getProjectTasksBy(id: UUID, completion: @escaping ([TaskDetailModel]) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Создать проект
     
     - parameters:
        - project: Проект, который необходимо создать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func createProject(_ project: EditProjectModel, completion: @escaping (Project) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Создать задачу
     
     - parameters:
        - task: Задача, которую необходимо создать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func createTask(_ task: EditTaskModel, completion: @escaping (Task) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Создать сотрудника
     
     - parameters:
        - employee: Сотрудник, которого необходимо создать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func createEmployee(_ employee: EditEmployeeModel, completion: @escaping (Employee) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Редактировать проект
     
     - parameters:
        - editedProject: Проект, который необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editProject(_ editedProject: Project, completion: @escaping () -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Редактировать задачу
     
     - parameters:
        - editedTask: Задача, которую необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editTask(_ editedTask: Task, completion: @escaping () -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Редактировать сотрудника
     
     - parameters:
        - editedEmployee: Сотрудник, которого необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editEmployee(_ editedEmployee: Employee, completion: @escaping () -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Удалить задачу
     
     - parameters:
        - id: Идентификатор задачи, которую необходимо удалить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func deleteTaskWith(id: UUID, completion: @escaping () -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Удалить проект
     
     - parameters:
        - id: Идентификатор проекта, который необходимо удалить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func deleteProjectWith(id: UUID, completion: @escaping () -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Удалить сотрудника
     
     - parameters:
        - id: Идентификатор сотрудника, которого необходимо удалить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func deleteEmployeeWith(id: UUID, completion: @escaping () -> Void, error: @escaping (Error) -> (Void))
    
}
