import Foundation

/**
 Данный класс выступает в качестве "Хранилища" настроек
 */
class SettingsStorage {
    private let userDefaults = UserDefaults.standard
    private let settingsStorageKey = "settingsStorageKey"
    
    /**
     Загрузить настройки
     
     - throws: Ошибка при загрузке
     - returns: Настройки приложения
     */
    @discardableResult
    func getSettings() throws -> Settings {
        guard let settingsData = userDefaults.data(forKey: settingsStorageKey) else {
            let error = AppError(message: "Отсутсвует модель данных Settings в хранилище")
            throw error
        }
        return try JSONDecoder().decode(Settings.self, from: settingsData)
    }
    
    /**
     Сохранить настройки
     
     -  parameters:
        - settings: Модель настроек
     
     - throws: Ошибка при сохранении настроек
     */
    func store(settings: Settings) throws {
        let settingsData = try JSONEncoder().encode(settings)
        userDefaults.setValue(settingsData, forKey: settingsStorageKey)
    }
}
