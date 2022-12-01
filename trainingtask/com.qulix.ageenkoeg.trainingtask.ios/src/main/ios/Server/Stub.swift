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
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getProjects(completion: @escaping ([Project]) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            completion(self.projects)
        })
    }
    
    /**
     Получить задачи проекта
     
     - parameters:
        - id: Идентификатор проекта
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getProjectTasksBy(id: UUID, completion: @escaping ([TaskDetailModel]) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            if let project = self.projects.first(where: { $0.id == id }) {
                let filteredTasks = self.tasks.filter({ $0.projectId == id })
                let result = filteredTasks.map { task in
                    TaskDetailModel(
                        task: task,
                        project: project,
                        employee: self.employees.first(where: { $0.id == task.employeeId })
                    )
                }
                completion(result)
            } else {
                let errorMessage = "Не удалось найти проект по id"
                error(AppError(message: errorMessage))
            }
        })
    }
    
    /**
     Получить задачи
     
     - parameters:
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getTasks(completion: @escaping ([TaskDetailModel]) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            var result = [TaskDetailModel]()
            for task in self.tasks {
                if let project = self.projects.first(where: { $0.id == task.projectId }) {
                    result.append(TaskDetailModel(
                        task: task,
                        project: project,
                        employee: self.employees.first(where: { $0.id == task.employeeId })
                    ))
                }
            }
            completion(result)
        })
    }
    
    /**
     Получить сотрудников
     
     - parameters:
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func getEmployees(completion: @escaping ([Employee]) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            completion(self.employees)
        })
    }
    
    /**
     Создать проект
     
     - parameters:
        - project: Проект, который необходимо создать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func createProject(_ project: EditProjectModel, completion: @escaping (Project) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            let id = UUID()
            if self.projects.contains(where: { $0.id == id }) == false {
                let project = Project(
                    name: project.name,
                    description: project.description,
                    id: id)
                self.projects.append(project)
                completion(project)
            } else {
                let errorMessage = "Проект с таким id уже существует"
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
    func createTask(_ task: EditTaskModel, completion: @escaping (Task) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            let id = UUID()
            if self.tasks.contains(where: { $0.id == id }) == false {
                let task = Task(
                    name: task.name,
                    projectId: task.projectId,
                    timeToComplete: task.timeToComplete,
                    startDate: task.startDate,
                    endDate: task.endDate,
                    status: task.status,
                    employeeId: task.employeeId,
                    id: id
                )
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
    func createEmployee(_ employee: EditEmployeeModel, completion: @escaping (Employee) -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            let id = UUID()
            if self.employees.contains(where: { $0.id == id }) == false {
                let employee = Employee(
                    surName: employee.surName,
                    name: employee.name,
                    middleName: employee.middleName,
                    position: employee.position,
                    id: id
                )
                self.employees.append(employee)
                completion(employee)
            } else {
                let errorMessage = "Сотрудник с таким id уже существует"
                error(AppError(message: errorMessage))
            }
        })
    }
    
    /**
     Редактировать проект
     
     - parameters:
        - editedProject: Проект, который необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editProject(_ editedProject: Project, completion: @escaping () -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            guard let projectData = self.projects.enumerated().first(where: { $0.element.id == editedProject.id }) else {
                let errorMessage = "Выбранный проект не существует"
                error(AppError(message: errorMessage))
                return
            }
            let projectIndex = projectData.offset
            let projectToInsert = Project(
                name: editedProject.name,
                description: editedProject.description,
                id: editedProject.id)
            self.projects.remove(at: projectIndex)
            self.projects.insert(projectToInsert, at: projectIndex)
            completion()
        })
    }

    /**
     Редактировать задачу
     
     - parameters:
        - editedTask: Задача, которую необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editTask(_ editedTask: Task, completion: @escaping () -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            guard let taskData = self.tasks.enumerated().first(where: { $0.element.id == editedTask.id }) else {
                let errorMessage = "Выбранная задача не существует"
                error(AppError(message: errorMessage))
                return
            }
            let taskIndex = taskData.offset
            let taskToInsert = Task(
                name: editedTask.name,
                projectId: editedTask.projectId,
                timeToComplete: editedTask.timeToComplete,
                startDate: editedTask.startDate,
                endDate: editedTask.endDate,
                status: editedTask.status,
                employeeId: editedTask.employeeId,
                id: editedTask.id
            )
            self.tasks.remove(at: taskIndex)
            self.tasks.insert(taskToInsert, at: taskIndex)
            completion()
        })
    }
    
    /**
     Редактировать сотрудника
     
     - parameters:
        - editedEmployee: Сотрудник, которого необходимо отредактировать
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func editEmployee(_ editedEmployee: Employee, completion: @escaping () -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            guard let employeeData = self.employees.enumerated().first(where: { $0.element.id == editedEmployee.id }) else {
                let errorMessage = "Выбранный сотрудник не существует"
                error(AppError(message: errorMessage))
                return
            }
            let employeeIndex = employeeData.offset
            let employeeToInsert = Employee(
                surName: editedEmployee.surName,
                name: editedEmployee.name,
                middleName: editedEmployee.middleName,
                position: editedEmployee.position,
                id: editedEmployee.id
            )
            self.employees.remove(at: employeeIndex)
            self.employees.insert(employeeToInsert, at: employeeIndex)
            completion()
        })
    }
    
    /**
     Удалить проект
     
     - parameters:
        - id: Идентификатор проекта, который необходимо удалить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func deleteProjectWith(id: UUID, completion: @escaping () -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            if let project = self.projects.first(where: { $0.id == id }) {
                self.projects.removeAll(where: { $0.id == project.id })
                self.deleteProjectTasks(projectId: id)
                completion()
            } else {
                let errorMessage = "Выбранный проект не существует"
                error(AppError(message: errorMessage))
            }
        })
    }
    
    /**
     Удалить задачу
     
     - parameters:
        - id: Идентификатор задачи, которую необходимо удалить
        - completion: Обработка ответа сервера
        - error: Обработка ошибочной ситуации
     */
    func deleteTaskWith(id: UUID, completion: @escaping () -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            if let task = self.tasks.first(where: { $0.id == id }) {
                self.tasks.removeAll(where: { $0.id == task.id })
                completion()
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
    func deleteEmployeeWith(id: UUID, completion: @escaping () -> Void, error: @escaping (Error) -> (Void)) {
        delay(completion: {
            if let employee = self.employees.first(where: { $0.id == id }) {
                self.employees.removeAll(where: { $0.id == employee.id })
                self.deleteEmoloyeeFromTask(taskId: id)
                completion()
            } else {
                let errorMessage = "Выбранный сотрудник не существует"
                error(AppError(message: errorMessage))
            }
        })
    }
    
    private func editProjectInTask(project: Project) {
        let filteredTasks = tasks.enumerated().filter({ $0.element.projectId == project.id })
        filteredTasks.forEach { taskData in
            let task = taskData.element
            let taskIndex = taskData.offset
            let taskToInsert = Task(
                name: task.name,
                projectId: project.id,
                timeToComplete: task.timeToComplete,
                startDate: task.startDate,
                endDate: task.endDate,
                status: task.status,
                employeeId: task.employeeId,
                id: task.id
            )
            tasks.remove(at: taskIndex)
            tasks.insert(taskToInsert, at: taskIndex)
        }
    }
    
    private func deleteProjectTasks(projectId: UUID) {
        self.tasks.removeAll(where: { $0.projectId == projectId })
    }
    
    private func editEmployeeInTask(employee: Employee) {
        let filteredTasks = tasks.enumerated().filter({ $0.element.employeeId == employee.id })
        filteredTasks.forEach { taskData in
            let task = taskData.element
            let taskIndex = taskData.offset
            let taskToInsert = Task(
                name: task.name,
                projectId: task.projectId,
                timeToComplete: task.timeToComplete,
                startDate: task.startDate,
                endDate: task.endDate,
                status: task.status,
                employeeId: task.employeeId,
                id: task.id
            )
            tasks.remove(at: taskIndex)
            tasks.insert(taskToInsert, at: taskIndex)
        }
    }
    
    private func deleteEmoloyeeFromTask(taskId: UUID) {
        guard let taskData = tasks.enumerated().first(where: { $0.element.id == taskId }) else {
            return
        }
        let task = taskData.element
        let taskIndex = taskData.offset
        let taskToInsert = Task(
            name: task.name,
            projectId: task.projectId,
            timeToComplete: task.timeToComplete,
            startDate: task.startDate,
            endDate: task.endDate,
            status: task.status,
            employeeId: nil,
            id: taskId
        )
        tasks.remove(at: taskIndex)
        tasks.insert(taskToInsert, at: taskIndex)
    }
}
