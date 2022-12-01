import Foundation

/**
 Структура валидации на экране "Редактирование задачи"
 */
struct EditTaskValidation {
    private let dateFormatter: DateService
    private let projects: [Project]
    private let employees: [Employee]
    
    /**
     Создает структуру валидации на экране "Редактирование задачи"
     
     - parameters:
        - projects: Реализация интерфейса сервера
        - employees: Настройки приложения
        - dateFormatter: Сервис по работе с датой
     */
    init(projects: [Project], employees: [Employee], dateFormatter: DateService) {
        self.dateFormatter = dateFormatter
        self.projects = projects
        self.employees = employees
    }
    
    /**
     Проверить валидность введенных данных на экране "Редактирование задачи"
     
     - parameters:
        - taskName: Название задачи
        - projectName: Название проекта
        - timeToComplete: Количество времени, необходимое для выполнения задачи
        - startDate: Дата начала задачи
        - endDate: Дата окончания задачи
        - status: Статус задачи
        - taskPerformer: Исполнитель задачи
     
     - returns: Результат проверки
    
     */
    func validateAndReturnResult(taskName: String?, projectName: String?, timeToComplete: String?,
                                 startDate: String?, endDate: String?, status: String?, taskPerformer: String?) -> EditTaskValidationResult {
        guard let name = taskName, !name.isEmpty else {
            let error = "Введите наименование"
            return .error(AppError(message: error))
        }
        
        guard let project = projectName, !project.isEmpty else {
            let error = "Выберите проект"
            return .error(AppError(message: error))
        }
    
        guard let projectId = projects.first(where: { $0.name == project })?.id else {
            let error = "Указанный проект не существует"
            return .error(AppError(message: error))
        }

        guard let timeToCompleteString = timeToComplete, !timeToCompleteString.isEmpty else {
            let error = "Укажите количество времени, необходимое для выполнения задачи"
            return .error(AppError(message: error))
        }
        
        guard let timeToComplete = Int(timeToCompleteString) else {
            let error = "Некорректный формат времени"
            return .error(AppError(message: error))
        }
        
        guard let startDateString = startDate, !startDateString.isEmpty else {
            let error = "Укажите дату начала"
            return .error(AppError(message: error))
        }
        
        guard let endDateString = endDate, !endDateString.isEmpty else {
            let error = "Укажите дату окончания"
            return .error(AppError(message: error))
        }
        
        guard let startDate = dateFormatter.date(from: startDateString) else {
            let error = "Некорректный формат даты начала"
            return .error(AppError(message: error))
        }
        
        guard let endDate = dateFormatter.date(from: endDateString) else {
            let error = "Некорректный формат даты окончания"
            return .error(AppError(message: error))
        }
        
        if endDate < startDate {
            let error = "Дата начала не может быть меньше даты окончания"
            return .error(AppError(message: error))
        }
        
        guard let statusValue = status else {
            let error = "Выберите статус"
            return .error(AppError(message: error))
        }
        
        guard let status = taskStatus(from: statusValue) else {
            let error = "Указанный статус не существует"
            return .error(AppError(message: error))
        }
        
        var employeeId: UUID?
        if let employee = taskPerformer, !employee.isEmpty {
            employeeId = employees.first(where: { $0.fullName == taskPerformer })?.id
            
            guard employees.contains(where: { $0.id == employeeId }) else {
                let error = "Указанный сотрудник не существует"
                return .error(AppError(message: error))
            }
        }
        
        let task = EditTaskModel(
            name: name,
            projectId: projectId,
            timeToComplete: timeToComplete,
            startDate: startDate,
            endDate: endDate,
            status: status,
            employeeId: employeeId
        )
        
        return .success(task)
    }
    
    private func taskStatus(from localizedStatus: String) -> TaskStatus? {
        return TaskStatusBuilder().build(from: localizedStatus)
    }
}
