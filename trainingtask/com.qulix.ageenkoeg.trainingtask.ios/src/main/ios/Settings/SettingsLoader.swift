import Foundation

/**
 Данный класс выступает в качестве "Загрузчика" настроек
 */
class SettingsLoader {
    private let url = "url"
    private let maxNumOfEntries = "maxNumOfEntries"
    private let numOfDaysBetweenDates = "numOfDaysBetweenDates"

    /**
     Загрузить настройки с plist файла
     
     - throws: Ошибка при загрузке
     - returns: Настройки приложения
     */
    func loadFromPlistFile() throws -> Settings {
        var format = PropertyListSerialization.PropertyListFormat.xml
        let initialSettingsList = "InitialSettingsList"
        let plist = "plist"
        guard let plistPath = Bundle.main.path(forResource: initialSettingsList, ofType: plist),
                let plistXML = FileManager.default.contents(atPath: plistPath) else {
            let error = "Неправильный путь к файлу / файл не существует"
            throw AppError(message: error)
        }
        let plistDataObject = try PropertyListSerialization.propertyList(from: plistXML, format: &format)
        guard let plistData = plistDataObject as? [String: AnyObject],
              let url = plistData[url] as? String,
              let maxNumOfEntries = plistData[maxNumOfEntries] as? String,
              let numOfDayBetweenDates = plistData[numOfDaysBetweenDates] as? String else {
            let error = "Ошибка при загрузке настроек из plist"
            throw AppError(message: error)
        }
        let settings = Settings(url: url, maxNumOfEntries: maxNumOfEntries, numOfDaysBetweenDates: numOfDayBetweenDates)
        return settings
    }
    
    /**
     Загрузить настройки с UserDefaults
     
     - throws: Ошибка при загрузке
     - returns: Настройки приложения
     */
    func loadFromUserDefaults() throws -> Settings {
        let userDefaults = UserDefaults()
        guard let url = userDefaults.value(forKey: url) as? String,
              let maxNumOfEntries = userDefaults.value(forKey: maxNumOfEntries) as? String,
              let numOfDaysBetweenDates = userDefaults.value(forKey: numOfDaysBetweenDates) as? String else {
            let error = "Ошибка при загрузке настроек из UserDefaults"
            throw AppError(message: error)
        }
        let settings = Settings(url: url, maxNumOfEntries: maxNumOfEntries, numOfDaysBetweenDates: numOfDaysBetweenDates)
        return settings
    }
}
