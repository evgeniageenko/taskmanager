import UIKit

/**
 Класс ячейки таблицы экрана "Список сотрудников"
 
 Данный класс отвечает за внешний вид ячейки таблицы на экране "Список сотрудников".
 */
class EmployeeCell: UITableViewCell {
    @IBOutlet private weak var surNameLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var middleNameLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    
    private let identifier = "EmployeeCell"

    /**
     Получить идентификатор ячейки
     
     - returns: Идентификатор ячейки
     */
    func getIdentifier() -> String {
        return identifier
    }
    
    /**
     Установить данные в ячейку таблицы
     
     - parameters:
        - model: Модель сотрудника, которая будет установлена в ячейку таблицы "Список сотрудников"
     */
    func bind(model: EmployeeCellModel) {
        surNameLabel.text = model.surName
        nameLabel.text = model.name
        middleNameLabel.text = model.middleName
        positionLabel.text = model.position
    }
    
    /**
     Очистить данные в ячейке таблицы
     */
    func unbind() {
        surNameLabel.text = nil
        nameLabel.text = nil
        middleNameLabel.text = nil
        positionLabel.text = nil
    }
}
