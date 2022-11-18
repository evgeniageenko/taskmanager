import Foundation

/**
 Данный класс выступает в качестве сервиса по работе с настройками
 */
class SettingsServise {
    private let settingsLoader = SettingsLoader()
    private let settingsStorage: SettingsStorage

    /**
    Создает сервис по работе с настройками
     */
    init() {
        let settings: Settings
        do {
            settings = try settingsLoader.loadFromUserDefaults()
        } catch {
            do {
            settings = try settingsLoader.loadFromPlistFile()
            } catch (let error) {
                fatalError(error.localizedDescription)
            }
        }
        self.settingsStorage = SettingsStorage(settings: settings)
    }
    
    /**
     Получить настройки
     
     - returns: Настройки приложения
     */
    func getSettings() -> Settings {
        settingsStorage.settings
    }
    
    /**
     Сохраниить настройки
     
     - parameters:
        - settings: Модель настроек
     */
    func saveSettings(_ settings: Settings) {
        settingsStorage.settings = settings
        
        let url = "url"
        let maxNumOfEntries = "maxNumOfEntries"
        let numOfDaysBetweenDates = "numOfDaysBetweenDates"
        UserDefaults.standard.setValue(settings.url, forKey: url)
        UserDefaults.standard.setValue(settings.maxNumOfEntries, forKey: maxNumOfEntries)
        UserDefaults.standard.setValue(settings.numOfDaysBetweenDates, forKey: numOfDaysBetweenDates)
    }

    /**
     Получить  "Максимальное количество записей в списках'"
     
     - returns: Максимальное количество записей в списках
     */
    func getLimit() -> Int {
        let settings = settingsStorage.settings
        var newCount = 0
        let maxNumOfEntries = settings.maxNumOfEntries
        if let limit = Int(maxNumOfEntries) {
            newCount = limit
        }
        return newCount
    }
    
    /**
     Получить "Количество дней по умолчанию между начальной и конечной датами в задаче'"
     
     - returns: Количество дней по умолчанию между начальной и конечной датами в задаче
     */
    func getNumberBetweenDays() -> Int {
        let settings = settingsStorage.settings
        var number = 0
        let numBetweenDays = settings.numOfDaysBetweenDates
        if let numBetweenDaysInt = Int(numBetweenDays) {
            number = numBetweenDaysInt
        }
        return number
    }
    
}

