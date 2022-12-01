import Foundation

/**
 Перечисление возможных действий на экране "Редактирование задачи"
 */
enum EditTaskMode {
    
    /**
     Создать задачу
     
     - parameters:
        - project: Проект (если переход был произведен с экрана "Проекты")
        - canEditProject: Проверка - можно ли редактировать поле "Название проекта"
     */
    case create(project: Project?, canEditProject: Bool)
    
    /**
     Редактировать задачу
     
     - parameters:
        - task: Модель описания задачи
     */
    case edit(task: TaskDetailModel)
}
