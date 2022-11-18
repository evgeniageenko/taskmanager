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
    
    /**
     Проверить валидность даты
     
     - parameters:
        - dateString: Дата, которую необходимо проверить
     
     - returns: Результат проверки (валидно или нет)
     */
    func checkForValidity(_ dateString: String) -> Bool {
        let components = dateString.components(separatedBy: ["-"])
        let yearInterval = (2022...)
        guard
            components.count == 3,
            components[0].count == 4,
            components[1].count == 2,
            components[2].count == 2,
            let date = self.date(from: dateString), let year = calendar.dateComponents([.year], from: date).year
        else { return false }
        
        return yearInterval.contains(year)
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
