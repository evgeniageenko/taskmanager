/**
Данный класс выступает в качестве хранилища настроек
 */
class SettingsStorage {
    var settings: Settings
    
    /**
     Создает хранилище настроек
     
     - parameters:
        - settings: Модель настроек приложения
     */
    init(settings: Settings) {
        self.settings = settings
    }
}

