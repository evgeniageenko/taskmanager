import UIKit

/**
Данный класс реализовывает методы "Изменения" и "Удаления" объектов по свайпу
*/
class SwipeActionManager {
    
    /**
    Изменить объект
    
    - parameters:
     - indexPath: Индекс строки
     - completion: Реализация изменения
     
    - returns: Действие "Изменить", когда пользователь проводит пальцем по строке таблицы
    */
    func edit(rowIndexPathAt indexPath: IndexPath, completion: @escaping () -> Void) -> UIContextualAction {
        let title = "Изменить"
        let editAction = UIContextualAction(style: .normal, title: title) { _, _, _ in
            completion()
        }
        return editAction
    }
    
    /**
     Удалить объект
     
     - parameters:
        - indexPath: Индекс строки
        - completion: Реализация удаления
     
     - returns: Действие "Удалить", когда пользователь проводит пальцем по строке таблицы
     */
    func delete(rowIndexPathAt indexPath: IndexPath, completion: @escaping () -> Void) -> UIContextualAction {
        let title = "Удалить"
        let deleteAction = UIContextualAction(style: .destructive, title: title) { _, _, _ in
            completion()
        }
        return deleteAction
    }
}
