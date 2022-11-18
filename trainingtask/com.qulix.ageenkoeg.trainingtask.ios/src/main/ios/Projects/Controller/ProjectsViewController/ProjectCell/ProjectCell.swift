import UIKit

/**
 Класс ячейки таблицы экрана "Список проектов"
 
 Данный класс отвечает за внешний вид ячейки таблицы на экране "Список проектов".
 */
class ProjectCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private let identifier = "ProjectCell"
    
    /**
     Получить идентификатор ячейки
     
     - returns: Идентификатор ячейки
     */
    func getIdentifier() -> String {
        return identifier
    }
    
    /**
     Передать модель проекта в ячейку
     
     - parameters:
        - model: Модель проекта
     */
    func setUpProjectWith(_ model: ProjectCellModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
    }
}


