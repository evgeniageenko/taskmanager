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
     Передать модель сотрудника в ячейку
     
     - parameters:
        - model: Модель сотрудника
     */
    func setUpEmployeeWith(_ model: EmployeeCellModel) {
        surNameLabel.text = model.surName
        nameLabel.text = model.name
        middleNameLabel.text = model.middleName
        positionLabel.text = model.position
    }
}
