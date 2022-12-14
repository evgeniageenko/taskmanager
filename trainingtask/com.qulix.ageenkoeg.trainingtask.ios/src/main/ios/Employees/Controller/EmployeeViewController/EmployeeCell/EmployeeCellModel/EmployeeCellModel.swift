/**
 Структура ячейки таблицы экрана "Список сотрудников"
 
 Данная структура описывает модель сотрудника, которая будет установлена в ячейку EmployeeCell.
 */
struct EmployeeCellModel {
    
    /**
     Фамилия сотрудника
     */
    let surName: String
    
    /**
     Имя сотрудника
     */
    let name: String
    
    /**
     Отчество сотрудника
     */
    let middleName: String
    
    /**
     Должность сотрудника
     */
    let position: String
}
