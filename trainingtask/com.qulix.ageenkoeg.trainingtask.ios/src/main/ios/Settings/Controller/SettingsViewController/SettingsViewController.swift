import UIKit

/**
 Класс экрана "Настройки"
 */
class SettingsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet private weak var urlTextField: UITextField!
    @IBOutlet private weak var maxNumOfEntriesTextField: UITextField!
    @IBOutlet private weak var numOfDaysBetweenDatesTextField: UITextField!
    
    private let settingsService: SettingsServise
    
    /**
     Создает экран "Настройки"
     
     - parameters:
        - settingsService: Сервис по работе с настройками
     */
    init(settingsService: SettingsServise) {
        self.settingsService = settingsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        bind(settingsService.getSettings())
        setTextFieldsDelegates()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTitle()
    }
    
    private func setTextFieldsDelegates() {
        urlTextField.delegate = self
        maxNumOfEntriesTextField.delegate = self
        numOfDaysBetweenDatesTextField.delegate = self
    }
    
    private func setUpTitle() {
        let title = "Настройки"
        let topItemTitle = "Отмена"
        self.title = title
        self.navigationController?.navigationBar.topItem?.title = topItemTitle
    }
    
    private func bind(_ model: Settings) {
        urlTextField.text = model.url.absoluteString
        maxNumOfEntriesTextField.text = String(model.maxNumOfEntries)
        numOfDaysBetweenDatesTextField.text = String(model.numOfDaysBetweenDates)
    }
    
    private func unbind() throws -> Settings {
       let validation = SettingsValidation()
       
        let validationResult = validation.validateAndReturnResult(
            url: urlTextField.text,
            maxNumOfEntries: maxNumOfEntriesTextField.text,
            numOfDaysBetweenDates: numOfDaysBetweenDatesTextField.text
        )
        
        switch validationResult {
        case .success(let settings):
            urlTextField.text = nil
            maxNumOfEntriesTextField.text = nil
            numOfDaysBetweenDatesTextField.text = nil
            return settings
        case .error(let error):
            throw error
        }
    }
    
    @IBAction private func saveButtonAction(_ sender: Any) {
        do {
            let model = try unbind()
            settingsService.saveSettings(model)
            self.navigationController?.popViewController(animated: true)
        } catch let error {
            showAlertWith(error.localizedDescription)
        }
    }
    
    private func showAlertWith(_ message: String) {
        let alertTitle = "Ошибка"
        let actionTitle = "Ок"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func tap(_ sender: Any) {
        urlTextField.resignFirstResponder()
        maxNumOfEntriesTextField.resignFirstResponder()
        numOfDaysBetweenDatesTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case urlTextField:
            textField.keyboardType = .default
        case maxNumOfEntriesTextField:
            textField.keyboardType = .numberPad
        case numOfDaysBetweenDatesTextField:
            textField.keyboardType = .numberPad
        default:
            return
        }
    }
}


