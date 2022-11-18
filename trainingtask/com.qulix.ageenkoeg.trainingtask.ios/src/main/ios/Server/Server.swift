import Foundation

/**
 Интерфейс взаимодействия с сервером
 
 Данный протокол описывает методы работы сервера.
 */
protocol Server {
    
    /**
     Получить проекты
     
     - parameters:
        - limit: Устанавливает кол-во проектов, которое необходимо загрузить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getProjectsWith(limit: Int?, completion: @escaping ([Project]) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Получить задачи
     
     - parameters:
        - limit: Устанавливает кол-во задач, которое необходимо загрузить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getTasksWith(limit: Int?, completion: @escaping ([Task]) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Получить сотрудников
     
     - parameters:
        - limit: Устанавливает кол-во сотрудников, которое необходимо загрузить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getEmployeesWith(limit: Int?, completion: @escaping ([Employee]) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Получить задачи проекта
     
     - parameters:
        - id: Идентификатор проекта
        - limit: Устанавливает кол-во задач, которое необходимо загрузить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getProjectTasksBy(id: UUID, limit: Int?, completion: @escaping ([Task]) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Создать проект
     
     - parameters:
        - project: Проект, который необходимо создать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func createProject(_ project: Project, completion: @escaping (Project) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Создать задачу
     
     - parameters:
        - task: Задача, которую необходимо создать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func createTask(_ task: Task, completion: @escaping (Task) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Создать сотрудника
     
     - parameters:
        - employee: Сотрудник, которого необходимо создать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func createEmployee(_ employee: Employee, completion: @escaping (Employee) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Редактировать проект
     
     - parameters:
        - project: Проект, который необходимо отредактировать
        - id: Идентификатор проекта, который необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editProject(_ project: Project, id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Редактировать задачу
     
     - parameters:
        - task: Задача, которую необходимо отредактировать
        - id: Идентификатор задачи, которую необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editTask(_ task: Task, id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Редактировать сотрудника
     
     - parameters:
        - employee: Сотрудник, которого необходимо отредактировать
        - id: Идентификатор сотрудника, которого необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editEmployee(_ employee: Employee, id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Удалить задачу
     
     - parameters:
        - id: Идентификатор задачи, которую необходимо удалить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func deleteTaskWith(id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Удалить проект
     
     - parameters:
        - id: Идентификатор проекта, который необходимо удалить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func deleteProjectWith(id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void))
    
    /**
     Удалить сотрудника
     
     - parameters:
        - id: Идентификатор сотрудника, которого необходимо удалить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func deleteEmployeeWith(id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void))
    
}
