import UIKit

/**
 Класс ячейки таблицы экрана "Список задач"
 
 Данный класс отвечает за внешний вид ячейки таблицы на экране "Список задач".
 */
class TaskCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var projectLabel: UILabel!
    @IBOutlet private weak var statusImage: UIImageView!
    
    private let identifier = "TaskCell"

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
        - model: Модель задачи, которая будет установлена в ячейку таблицы "Список задач"
     */
    func bind(model: TaskCellModel) {
        nameLabel.text = model.name
        
        switch model.status {
        case .notStarted:
            statusImage.image = UIImage(named: "open")
        case .inProgress:
            statusImage.image = UIImage(named: "inprogress")
        case .done:
            statusImage.image = UIImage(named: "done")
        case .postponed:
            statusImage.image = UIImage(named: "postponed")
        }
        
        if model.isOpenFromProjectVC {
            projectLabel.isHidden = true
        } else {
            projectLabel.text = model.projectName
        }
    }
    
    /**
     Очистить данные в ячейке таблицы
     */
    func unbind() {
        nameLabel.text = nil
        statusImage.image = nil
        projectLabel.text = nil
        projectLabel.isHidden = false
    }
}
