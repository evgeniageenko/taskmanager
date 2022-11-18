import Foundation

/**
 Класс модели "Настройки"
 */
class Settings {
    
    /**
     url
     */
    var url: String
    
    /**
     Максимальное количество записей в списках
     */
    var maxNumOfEntries: String
    
    /**
     Количество дней по умолчанию между начальной и конечной датами в задаче
     */
    var numOfDaysBetweenDates: String
    
    /**
     Создает объект "Настройки"
     
     - parameters:
        - url: url
        - maxNumOfEntries: Максимальное количество записей в списках
        - numOfDaysBetweenDates: Количество дней по умолчанию между начальной и конечной датами в задаче
     */
    init(url: String, maxNumOfEntries: String, numOfDaysBetweenDates: String) {
        self.url = url
        self.maxNumOfEntries = maxNumOfEntries
        self.numOfDaysBetweenDates = numOfDaysBetweenDates
    }
}
