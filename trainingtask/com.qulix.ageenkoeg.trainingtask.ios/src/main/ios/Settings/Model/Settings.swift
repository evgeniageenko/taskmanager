import Foundation

/**
 Класс модели "Настройки"
 */
struct Settings: Codable {
    
    /**
     url
     */
    let url: URL
    
    /**
     Максимальное количество записей в списках
     */
    let maxNumOfEntries: Int
    
    /**
     Количество дней по умолчанию между начальной и конечной датами в задаче
     */
    let numOfDaysBetweenDates: Int
    
    /**
     Создает объект "Настройки"
     
     - parameters:
        - url: url
        - maxNumOfEntries: Максимальное количество записей в списках
        - numOfDaysBetweenDates: Количество дней по умолчанию между начальной и конечной датами в задаче
     */
    init(url: URL, maxNumOfEntries: Int, numOfDaysBetweenDates: Int) {
        self.url = url
        self.maxNumOfEntries = maxNumOfEntries
        self.numOfDaysBetweenDates = numOfDaysBetweenDates
    }
}
