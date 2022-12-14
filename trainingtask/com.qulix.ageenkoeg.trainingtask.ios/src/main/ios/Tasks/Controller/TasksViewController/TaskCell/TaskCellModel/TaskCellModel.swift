/**
 Структура ячейки таблицы экрана "Список задач"
 
 Данная структура описывает модель задачи, которая будет установлена в ячейку TaskCell.
 */
struct TaskCellModel {
    
    /**
     Название задачи
     */
    let name: String
    
    /**
     Название проекта, к которому относится задача
     */
    let projectName: String
    
    /**
     Статус задачи
     */
    let status: TaskStatus
    
    /**
     Проверка - был ли произведен переход на экран с экрана "Список проектов"
     */
    let isOpenFromProjectVC: Bool
}
