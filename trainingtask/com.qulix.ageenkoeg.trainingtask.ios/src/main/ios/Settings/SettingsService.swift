import Foundation

/**
 Данный класс выступает в качестве сервиса по работе с настройками
 */
class SettingsServise {
    private let settingsLoader = SettingsLoader()
    private let settingsStorage = SettingsStorage()

    /**
    Создает сервис по работе с настройками
     */
    init() {
        do {
            try settingsStorage.getSettings()
        } catch {
            do {
                let settings = try settingsLoader.loadFromPlistFile()
                try settingsStorage.store(settings: settings)
            } catch (let error) {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    /**
     Получить настройки
     
     - returns: Настройки приложения
     */
    func getSettings() -> Settings {
        do {
            return try settingsStorage.getSettings()
        } catch (let error) {
            fatalError(error.localizedDescription)
        }
    }
    
    /**
     Сохранить настройки
     
     - parameters:
        - settings: Модель настроек
     */
    func saveSettings(_ settings: Settings) {
        do {
            try settingsStorage.store(settings: settings)
        } catch (let error) {
            fatalError(error.localizedDescription)
        }
    }
}
