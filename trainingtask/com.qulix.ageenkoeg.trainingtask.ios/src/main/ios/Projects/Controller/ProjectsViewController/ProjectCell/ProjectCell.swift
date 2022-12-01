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
     Установить данные в ячейку таблицы
     
     - parameters:
        - model: Модель проекта, которая будет установлена в ячейку таблицы "Список проектов"
     */
    func bind(model: ProjectCellModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
    }
    
    /**
     Очистить данные в ячейке таблицы
     */
    func unbind() {
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
}
