import UIKit

/**
 Данный класс отвечает за добавление и редактирование сотрудника
 */
class EditEmployeeViewController: UIViewController {
    @IBOutlet private weak var surNameTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var middleNameTextField: UITextField!
    @IBOutlet private weak var positionTextField: UITextField!
    
    private let employee: Employee?
    
    /**
     Делегат интерфейса EditEmployeeViewControllerDelegate
     */
    var delegate: EditEmployeeViewControllerDelegate?
    
    /**
     Создает экран "Редактирование сотрудника"
     
     - parameters:
        - employee: Сотрудник (если переход был произведен с помощью кнопки "Изменить")
     */
    init(employee: Employee?) {
        self.employee = employee
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        bind(employee)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTitle()
    }
    
    private func setUpTitle() {
        let title = "Редактирование сотрудника"
        self.title = title
    }
    
    private func bind(_ model: Employee?) {
        surNameTextField.text = model?.surName
        nameTextField.text = model?.name
        middleNameTextField.text = model?.middleName
        positionTextField.text = model?.position
        
    }
    
    private func unbind() throws -> Employee {
        guard let surName = surNameTextField.text, !surName.isEmpty else {
            let error = "Введите фамилию"
            throw AppError(message: error)
        }
        
        guard let name = nameTextField.text, !name.isEmpty else {
            let error = "Введите имя"
            throw AppError(message: error)
        }
        
        guard let middleName = middleNameTextField.text, !middleName.isEmpty else {
            let error = "Введите отчество"
            throw AppError(message: error)
        }
        
        guard let position = positionTextField.text, !position.isEmpty else {
            let error = "Укажите должность"
            throw AppError(message: error)
        }
        
        surNameTextField.text = nil
        nameTextField.text = nil
        middleNameTextField.text = nil
        positionTextField.text = nil
        
        let employee = Employee(surName: surName, name: name, middleName: middleName, position: position, id: employee?.id)
        
        return employee
    }
    
    @IBAction private func saveButtonAction(_ sender: Any) {
        do {
            let model = try unbind()
            delegate?.saveEmployee(model: model, isOpenFromAddButton: employee == nil)
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
        surNameTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        middleNameTextField.resignFirstResponder()
        positionTextField.resignFirstResponder()
    }
}

