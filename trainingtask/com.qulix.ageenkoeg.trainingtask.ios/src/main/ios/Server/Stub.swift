import Foundation

/**
 Стаб-реализация сервера
 
 Класс реализует интерфейс взаимодействия с сервером. Задержка в 1000мс имитирует работу сервера.
 */
class Stub: Server {
    private var projects: [Project] = []
    private var tasks: [Task] = []
    private var employees: [Employee] = []
    private let queue = DispatchQueue.global(qos: .utility)
    private let delayInSeconds = 1000

    private func delay(completion: @escaping () -> (Void)) {
        queue.asyncAfter(deadline: .now() + .milliseconds(delayInSeconds)) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    /**
     Получить проекты
     
     - parameters:
        - limit: Устанавливает кол-во проектов, которое необходимо загрузить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getProjectsWith(limit: Int?, completion: @escaping ([Project]) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            var projectsCount = self.projects.count
            
            let limit = limit ?? projectsCount
            if limit < projectsCount {
                projectsCount = limit
            }
            completion(Array(self.projects[...(projectsCount - 1)]))
        })
    }
    
    /**
     Получить задачи
     
     - parameters:
        - limit: Устанавливает кол-во задач, которое необходимо загрузить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getTasksWith(limit: Int?, completion: @escaping ([Task]) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            var tasksCount = self.tasks.count
            
            let limit = limit ?? tasksCount
            if limit < tasksCount {
                tasksCount = limit
            }
            completion(Array(self.tasks[...(tasksCount - 1)]))
        })
        
    }
    
    /**
     Получить сотрудников
     
     - parameters:
        - limit: Устанавливает кол-во сотрудников, которое необходимо загрузить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getEmployeesWith(limit: Int?, completion: @escaping ([Employee]) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            var employeesCount = self.employees.count
            
            let limit = limit ?? employeesCount
            if limit < employeesCount {
                employeesCount = limit
            }
            completion(Array(self.employees[...(employeesCount - 1)]))
        })
    }
    
    /**
     Получить задачи проекта
     
     - parameters:
        - id: Идентификатор проекта
        - limit: Устанавливает кол-во задач, которое необходимо загрузить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getProjectTasksBy(id: UUID, limit: Int?, completion: @escaping ([Task]) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            if self.projects.contains(where: {$0.id == id}) {
                let tasks = self.tasks.filter({$0.projectId == id})
                var tasksCount = tasks.count
                
                let limit = limit ?? tasksCount
                if limit < tasksCount {
                    tasksCount = limit
                    completion(Array(tasks[...(tasksCount - 1)]))
                } else {
                    completion(tasks)
                }
            } else {
                let errorMessage = "Не удалость найти проект по id"
                error(AppError(message: errorMessage))
            }
        })
    }
    
    /**
     Создать проект
     
     - parameters:
        - project: Проект, который необходимо создать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func createProject(_ project: Project, completion: @escaping (Project) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            let id = UUID()
            if self.projects.contains(where: {$0.name == project.name}) == false {
                if self.projects.contains(where: {$0.id == id}) == false {
                    let project = Project(name: project.name, description: project.description, tasks: project.tasks, id: id)
                    self.projects.append(project)
                    completion(project)
                } else {
                    let errorMessage = "Проект с таким id уже существует"
                    error(AppError(message: errorMessage))
                }} else {
                    let errorMessage = "Проект с таким названием уже существует"
                    error(AppError(message: errorMessage))
                }
        })
    }
    
    /**
     Создать задачу
     
     - parameters:
        - task: Задача, которую необходимо создать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func createTask(_ task: Task, completion: @escaping (Task) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            let id = UUID()
            if self.tasks.contains(where: {$0.id == id}) == false {
                let task = Task(name: task.name, project: task.project,
                                projectId: task.projectId, timeToComplete: task.timeToComplete,
                                startDate: task.startDate, endDate: task.endDate,
                                status: task.status, employeeName: task.employeeName,
                                employeeId: task.employeeId, id: id)
                self.tasks.append(task)
                completion(task)
            } else {
                let errorMessage = "Задача с таким id уже существует"
                error(AppError(message: errorMessage))
            }
        })
    }
   
    /**
     Создать сотрудника
     
     - parameters:
        - employee: Сотрудник, которого необходимо создать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func createEmployee(_ employee: Employee, completion: @escaping (Employee) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            let id = UUID()
            if self.employees.contains(where: {$0.fullName == employee.fullName}) == false {
                if self.employees.contains(where: {$0.id == id}) == false {
                    let employee = Employee(surName: employee.surName, name: employee.name,
                                            middleName: employee.middleName, position: employee.position, id: id)
                    self.employees.append(employee)
                    completion(employee)
                } else {
                    let errorMessage = "Сотрудник с таким id уже существует"
                    error(AppError(message: errorMessage))
                }} else {
                    let errorMessage = "Сотрудник с таким ФИО уже существует"
                    error(AppError(message: errorMessage))
                }
        })
    }
    
    /**
     Редактировать проект
     
     - parameters:
        - project: Проект, который необходимо отредактировать
        - id: Идентификатор проекта, который необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editProject(_ project: Project, id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            if let editProject = self.projects.first(where: {$0.id == id}) {
                editProject.name = project.name
                editProject.description = project.description
                editProject.tasks = project.tasks
                self.editProjectInTask(project: editProject)
                completion(true)
            } else {
                let errorMessage = "Выбранный проект не существует"
                error(AppError(message: errorMessage))
            }
        })
    }
    
    private func editProjectInTask(project: Project) {
        self.tasks.forEach({ if $0.projectId == project.id {
            $0.project = project.name
        }})
    }
    
    /**
     Редактировать задачу
     
     - parameters:
        - task: Задача, которую необходимо отредактировать
        - id: Идентификатор задачи, которую необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editTask(_ task: Task, id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            if let editTask = self.tasks.first(where: {$0.id == id}) {
                editTask.name = task.name
                editTask.project = task.project
                editTask.timeToComplete = task.timeToComplete
                editTask.startDate = task.startDate
                editTask.endDate = task.endDate
                editTask.status = task.status
                editTask.employeeName = task.employeeName
                editTask.employeeId = task.employeeId
                editTask.projectId = task.projectId
                completion(true)
            } else {
                let errorMessage = "Выбранная задача не существует"
                error(AppError(message: errorMessage))
            }
        })
    }
    
    /**
     Редактировать сотрудника
     
     - parameters:
        - employee: Сотрудник, которого необходимо отредактировать
        - id: Идентификатор сотрудника, которого необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editEmployee(_ employee: Employee, id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            if let editEmployee = self.employees.first(where: { $0.id == id}) {
                editEmployee.name = employee.name
                editEmployee.surName = employee.surName
                editEmployee.middleName = employee.middleName
                editEmployee.position = employee.position
                editEmployee.fullName = employee.fullName
                self.editEmployeeInTask(employee: editEmployee)
                completion(true)
            } else {
                let errorMessage = "Выбранный сотрудник не существует"
                error(AppError(message: errorMessage))
            }
        })
    }
    
    private func editEmployeeInTask(employee: Employee) {
        self.tasks.forEach({ if $0.employeeId == employee.id {
            $0.employeeName = employee.fullName
        }})
    }
    
    /**
     Удалить проект
     
     - parameters:
        - id: Идентификатор проекта, который необходимо удалить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func deleteProjectWith(id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            if let project = self.projects.first(where: {$0.id == id}) {
                self.projects.removeAll(where: {$0.id == project.id})
                self.deleteProjectFromTask(id: id)
                completion(true)
            } else {
                let errorMessage = "Выбранный проект не существует"
                error(AppError(message: errorMessage))
            }
        })
    }
    
    private func deleteProjectFromTask(id: UUID) {
        self.tasks.removeAll(where: {$0.projectId == id})
    }
    
    /**
     Удалить задачу
     
     - parameters:
        - id: Идентификатор задачи, которую необходимо удалить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func deleteTaskWith(id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            if let task = self.tasks.first(where: {$0.id == id}) {
                self.tasks.removeAll(where: { $0.id == task.id})
                completion(true)
            } else {
                let errorMessage = "Выбранная задача не существует"
                error(AppError(message: errorMessage))
            }
        })
    }
    
    /**
     Удалить сотрудника
     
     - parameters:
        - id: Идентификатор сотрудника, которого необходимо удалить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func deleteEmployeeWith(id: UUID, completion: @escaping (Bool) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            if let employee = self.employees.first(where: {$0.id == id}) {
                self.employees.removeAll(where: { $0.id == employee.id})
                self.deleteEmoloyeeFromTask(id: id)
                completion(true)
            } else {
                let errorMessage = "Выбранный сотрудник не существует"
                error(AppError(message: errorMessage))
            }
        })
    }
    
    private func deleteEmoloyeeFromTask(id: UUID) {
        self.tasks.forEach({ if $0.employeeId == id {
            $0.employeeName = nil
            $0.employeeId = nil
        }})
    }
}
