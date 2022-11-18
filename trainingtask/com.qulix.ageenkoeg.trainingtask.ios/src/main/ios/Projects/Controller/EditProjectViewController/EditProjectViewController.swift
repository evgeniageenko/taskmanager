import UIKit

/**
 Данный класс отвечает за добавление и редактирование проекта
 */
class EditProjectViewController: UIViewController {
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    
    private let project: Project?
    
    /**
     Делегат интерфейса EditProjectViewControllerDelegate
     */
    var delegate: EditProjectViewControllerDelegate?
    
    /**
     Создает экран "Редактирование проекта"
     
     - parameters:
        - project: Проект (если переход был произведен с помощью кнопки "Изменить")
     */
    init(project: Project?) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        bind(project)
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
    
    private func bind(_ model: Project?) {
        nameTextField.text = model?.name
        descriptionTextField.text = model?.description
    }
    
    private func unbind() throws -> Project {
        guard let name = nameTextField.text, !name.isEmpty else {
            let error = "Введите наименование"
            throw AppError(message: error)
        }
        
        guard let description = descriptionTextField.text, !description.isEmpty else {
            let error = "Введите описание"
            throw AppError(message: error)
        }
        
        nameTextField.text = nil
        descriptionTextField.text = nil
        
        let project = Project(name: name, description: description, tasks: project?.tasks, id: project?.id)
        
        return project
    }
    
    @IBAction private func saveButtonAction(_ sender: Any) {
        do {
            let model = try unbind()
            delegate?.saveProject(model: model, isOpenFromAddButton: project == nil)
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
