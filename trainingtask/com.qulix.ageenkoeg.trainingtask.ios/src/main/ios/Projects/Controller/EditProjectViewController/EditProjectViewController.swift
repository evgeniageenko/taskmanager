import UIKit

/**
 Данный класс отвечает за добавление и редактирование проекта
 */
class EditProjectViewController: UIViewController {
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    
    private let mode: EditProjectMode
    
    /**
     Делегат интерфейса EditProjectViewControllerDelegate
     */
    var delegate: EditProjectViewControllerDelegate?
    
    /**
     Создает экран "Редактирование проекта"
     
     - parameters:
        - mode: Перечисление возможных действий на экране
     */
    init(mode: EditProjectMode) {
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
        let title = "Редактирование проекта"
        let topItemTitle = "Назад"
        self.title = title
        self.navigationController?.navigationBar.topItem?.title = topItemTitle
    }
    
    private func bind(by mode: EditProjectMode) {
        switch mode {
        case .create:
            break
        case .edit(let project):
            nameTextField.text = project.name
            descriptionTextField.text = project.description
        }
    }
    
    private func unbind() throws -> EditProjectModel {
        let validation = EditProjectValidation()
        
        let validationResult = validation.validateAndReturnResult(
            name: nameTextField.text,
            descripion: descriptionTextField.text
        )
        
        switch validationResult {
        case .success(let project):
            nameTextField.text = nil
            descriptionTextField.text = nil
            return project
        case .error(let error):
            throw error
        }
    }
    
    @IBAction private func saveButtonAction(_ sender: Any) {
        do {
            let model = try unbind()
            switch mode {
            case .create:
                delegate?.createProject(model: model)
            case .edit(let project):
                let project = Project(
                    name: model.name,
                    description: model.description,
                    id: project.id
                )
                delegate?.editAndSaveProject(model: project)
            }
            self.navigationController?.popViewController(animated: true)
        } catch let error {
            showAlertWith(error.localizedDescription)
        }
    }
    
    @IBAction private func tap(_ sender: Any) {
        nameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
    
    private func showAlertWith(_ message: String) {
        let alertTitle = "Ошибка"
        let actionTitle = "Ок"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
