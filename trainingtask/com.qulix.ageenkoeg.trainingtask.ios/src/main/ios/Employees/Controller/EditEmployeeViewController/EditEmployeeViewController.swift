import UIKit

/**
 Данный класс отвечает за добавление и редактирование сотрудника
 */
class EditEmployeeViewController: UIViewController {
    @IBOutlet private weak var surNameTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var middleNameTextField: UITextField!
    @IBOutlet private weak var positionTextField: UITextField!
    
    private let mode: EditEmployeeMode
    
    /**
     Делегат интерфейса EditEmployeeViewControllerDelegate
     */
    var delegate: EditEmployeeViewControllerDelegate?
    
    /**
     Создает экран "Редактирование сотрудника"
     
     - parameters:
        - mode: Перечисление возможных действий на экране
     */
    init(mode: EditEmployeeMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        bind(by: mode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTitle()
    }
    
    private func setUpTitle() {
        let title = "Редактирование сотрудника"
        self.title = title
    }
    
    private func bind(by mode: EditEmployeeMode) {
        switch mode {
        case .create:
            break
        case .edit(let employee):
            surNameTextField.text = employee.name
            nameTextField.text = employee.name
            middleNameTextField.text = employee.middleName
            positionTextField.text = employee.position
        }
    }
    
    private func unbind() throws -> EditEmployeeModel {
        let validation = EditEmployeeValidation()
        
        let validationResult = validation.validateAndReturnResult(
            surName: surNameTextField.text,
            name: nameTextField.text,
            middleName: middleNameTextField.text,
            position: positionTextField.text
        )
        
        switch validationResult {
        case .success(let employee):
            surNameTextField.text = nil
            nameTextField.text = nil
            middleNameTextField.text = nil
            positionTextField.text = nil
            return employee
        case .error(let error):
            throw error
        }
    }
    
    @IBAction private func saveButtonAction(_ sender: Any) {
        do {
            let model = try unbind()
            switch mode {
            case .create:
                delegate?.createEmployee(model: model)
            case .edit(let employee):
                let employee = Employee(
                    surName: model.surName,
                    name: model.name,
                    middleName: model.middleName,
                    position: model.position,
                    id: employee.id
                )
                delegate?.editAndSaveEmployee(model: employee)
            }
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

