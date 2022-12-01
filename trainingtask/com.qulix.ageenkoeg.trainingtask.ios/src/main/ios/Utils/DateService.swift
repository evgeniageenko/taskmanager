import Foundation

/**
 Класс выступает в качестве сервиса по работе с датой
 */
class DateService: DateFormatter {
    private let format = "yyyy-MM-dd"
    override init() {
        super.init()
        dateFormat = format
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func date(from string: String) -> Date? {
        guard string.count == format.count else {
            return nil
        }
        
        let dateParts = string.components(separatedBy: "-")
        
        guard dateParts.count == 3 else {
            return nil
        }
        
        guard dateParts[0].count == 4,
              dateParts[1].count == 2,
              dateParts[2].count == 2 else {
            return nil
        }
        
        return super.date(from: string)
    }
    
    /**
     Добавить к дате количество дней между днями из настроек
     
     - parameters:
        - date: Дата, которую необходимо cкорректировать
        - numberBetweenDates: Количество дней между днями из настроек
     
     - returns: Дата, с учетом настроек
     */
    func adjustDate(_ date: Date, numberBetweenDates: Int) -> Date {
        return Date(timeInterval: daysInterval(days: numberBetweenDates), since: date)
    }
    
    private func daysInterval(days: Int) -> TimeInterval {
        let hoursInOneDay = 24
        let minutesInOneHour = 60
        let secondsInOneMinute = 60
        
        return TimeInterval(days * hoursInOneDay * minutesInOneHour * secondsInOneMinute)
    }
}
