import UIKit

/**
 Данный класс отвечает за добавление и редактирование задачи
 */
class EditTaskViewController: UIViewController {
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var projectTextField: UITextField!
    @IBOutlet private weak var timeToCompleteTaskTextField: UITextField!
    @IBOutlet private weak var startDateTextField: UITextField!
    @IBOutlet private weak var endDateTextField: UITextField!
    @IBOutlet private weak var statusTextField: UITextField!
    @IBOutlet private weak var taskPerformerTextField: UITextField!
    
    private var projects: [Project] = []
    private var employees: [Employee] = []
    private let mode: EditTaskMode
    private let itemPickerView = TaskItemPickerView()
    private var itemPickerTopConstraint: NSLayoutConstraint?
    private var itemPickerBottomConstraint: NSLayoutConstraint?
    private let datePickerView = TaskDatePickerView()
    private var datePickerTopConstraint: NSLayoutConstraint?
    private var datePickerBottomConstraint: NSLayoutConstraint?
    private let dateFormatter = DateService()
    private let settingsService: SettingsServise
    private let server: Server
    
    /**
     Делегат интерфейса EditTaskViewControllerDelegate
     */
    var delegate: EditTaskViewControllerDelegate?
    
    /**
     Создает экран "Редактирование задачи"
     
     - parameters:
        - mode: Перечисление возможных действий на экране
        - server: Реализация интерфейса сервера
        - settingsService: Настройки приложения
     */
    init(mode: EditTaskMode, server: Server, settingsService: SettingsServise) {
        self.mode = mode
        self.server = server
        self.settingsService = settingsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        bind(by: mode)
        setUpItemPicker()
        setUpDatePicker()
        setUpTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTitle()
    }
    
    private func setUpTitle() {
        let title = "Редактирование задачи"
        let topItemTitle = "Назад"
        self.title = title
        self.navigationController?.navigationBar.topItem?.title = topItemTitle
    }
    
    private func bind(by mode: EditTaskMode) {
        let startDate = Date()
        let endDate = dateFormatter.adjustDate(
            startDate,
            numberBetweenDates: settingsService.getSettings().numOfDaysBetweenDates
        )
        startDateTextField.text = dateFormatter.string(for: startDate)
        endDateTextField.text = dateFormatter.string(for: endDate)
        
        switch mode {
        case .create(let project, let canEditProject):
            projectTextField.text = project?.name
            projectTextField.isUserInteractionEnabled = !canEditProject
        case .edit(let taskDetails):
            let task = taskDetails.task
            nameTextField.text = task.name
            projectTextField.text = taskDetails.project.name
            timeToCompleteTaskTextField.text = String(task.timeToComplete)
            startDateTextField.text = dateFormatter.string(for: task.startDate)
            endDateTextField.text = dateFormatter.string(for: task.endDate)
            statusTextField.text = localizedStatus(task.status)
            taskPerformerTextField.text = taskDetails.employee?.fullName
        }
    }
    
    private func unbind() throws -> EditTaskModel {
        let validation = EditTaskValidation(
            projects: projects,
            employees: employees,
            dateFormatter: dateFormatter
        )
        
        let validationResult = validation.validateAndReturnResult(
            taskName: nameTextField.text,
            projectName: projectTextField.text,
            timeToComplete: timeToCompleteTaskTextField.text,
            startDate: startDateTextField.text,
            endDate: endDateTextField.text,
            status: statusTextField.text,
            taskPerformer: taskPerformerTextField.text
        )

        switch validationResult {
        case .success(let task):
            nameTextField.text = nil
            projectTextField.text = nil
            timeToCompleteTaskTextField.text = nil
            startDateTextField.text = nil
            endDateTextField.text = nil
            statusTextField.text = nil
            taskPerformerTextField.text = nil
            return task
        case .error(let error):
            throw error
        }
    }
    
    private func setUpItemPicker() {
        itemPickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(itemPickerView)
        
        NSLayoutConstraint.activate([
            itemPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        itemPickerTopConstraint = itemPickerView.topAnchor.constraint(equalTo: view.bottomAnchor)
        itemPickerTopConstraint?.isActive = true
        itemPickerBottomConstraint = itemPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    }
    
    private func setUpDatePicker() {
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePickerView)
        
        NSLayoutConstraint.activate([
            datePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        datePickerTopConstraint = datePickerView.topAnchor.constraint(equalTo: view.bottomAnchor)
        datePickerTopConstraint?.isActive = true
        datePickerBottomConstraint = datePickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    }
    
    private func getData() {
        getProjects()
        getEmployees()
    }
    
    private func getProjects() {
        server.getProjects(completion: { [weak self] projects in
            guard let self = self else {
                return
            }
            
            self.projects = projects
        }, error: { [weak self] error in
            self?.showAlertWith(error.localizedDescription)
        })
    }
    
    private func getEmployees() {
        server.getEmployees(completion: { [weak self] emoloyee in
            guard let self = self else {
                return
            }
            
            self.employees = emoloyee
        }, error: { [weak self] error in
            self?.showAlertWith(error.localizedDescription)
        })
    }
    
    private func showAlertWith(_ message: String) {
        let alertTitle = "Ошибка"
        let actionTitle = "Ок"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction private func saveButtonAction(_ sender: Any) {
        do {
            let model = try unbind()
            switch mode {
            case .create:
                delegate?.createTask(model: model)
            case .edit(let task):
                let task = Task(
                    name: model.name,
                    projectId: model.projectId,
                    timeToComplete: model.timeToComplete,
                    startDate: model.startDate,
                    endDate: model.endDate,
                    status: model.status,
                    employeeId: model.employeeId,
                    id: task.task.id)
                delegate?.editAndSaveTask(model: task)
            }
            self.navigationController?.popViewController(animated: true)
        } catch let error {
            showAlertWith(error.localizedDescription)
        }
    }
    
    @IBAction private func tap(_ sender: Any) {
        view.endEditing(true)
        hidePickers()
    }
    
    @IBAction private func showStartDatePicker() {
        var startDate = Date()
        
        if let date = startDateTextField.text, !date.isEmpty {
            guard let dateValue = dateFormatter.date(from: date) else {
                return
            }
            startDate = dateValue
        }
     
        showDatePicker(with: startDate, from: startDateTextField) { [weak self] date in
            self?.startDateTextField.text = self?.dateFormatter.string(from: date)
        }
    }
    
    @IBAction private func showEndDatePicker() {
        var endDate = Date()
              
        if let date = endDateTextField.text, !date.isEmpty {
            guard let dateValue = dateFormatter.date(from: date) else {
                return
            }
            endDate = dateValue
        }
        
        showDatePicker(with: endDate, from: endDateTextField) { [weak self] date in
            self?.endDateTextField.text = self?.dateFormatter.string(from: date)
        }
    }
    
    @objc private func showDatePickerFromFirstResponder() {
        if startDateTextField.isFirstResponder {
            startDateTextField.resignFirstResponder()
            showStartDatePicker()
        } else if endDateTextField.isFirstResponder {
            endDateTextField.resignFirstResponder()
            showEndDatePicker()
        }
    }
    
    @IBAction private func showProjectPicker() {
        let items = projects.compactMap({ project -> TaskItemPicker? in
            let id = project.id.uuidString
            return TaskItemPicker(id: id, title: project.name)
        })
        var selectedItem: TaskItemPicker?
        if let value = projectTextField.text,
           let project = projects.first(where: { $0.name == value }) {
          
            let projectId = project.id.uuidString
            selectedItem = TaskItemPicker(id: projectId, title: project.name)
        }
        
        showItemPicker(with: items, selectedItem: selectedItem) { [weak self] item in
            self?.projectTextField.text = item.title
        }
    }
    
    @IBAction private func showEmployeePicker() {
        let items = employees.compactMap({ employee -> TaskItemPicker? in
            let id = employee.id.uuidString
            return TaskItemPicker(id: id, title: employee.fullName)
        })
        var selectedItem: TaskItemPicker?
        if let value = taskPerformerTextField.text, let employee = employees.first(where: { $0.fullName == value }) {
            let employeeId = employee.id.uuidString
            selectedItem = TaskItemPicker(id: employeeId, title: employee.fullName)
        }
        
        showItemPicker(with: items, selectedItem: selectedItem) { [weak self] item in
            self?.taskPerformerTextField.text = item.title
        }
    }
    
    @IBAction private func showStatusPicker() {
        let items = TaskStatus.allCases.map({
            return TaskItemPicker(id: $0.rawValue, title: localizedStatus($0))
        })
        var selectedItem: TaskItemPicker?
        if let value = statusTextField.text,
           let status = taskStatus(from: value) {
            selectedItem = TaskItemPicker(id: status.rawValue, title: localizedStatus(status))
        }
        
        showItemPicker(with: items, selectedItem: selectedItem) { [weak self] item in
            self?.statusTextField.text = item.title
        }
    }
    
    private func localizedStatus(_ status: TaskStatus) -> String {
        return TaskStatusBuilder().string(from: status)
    }
    
    private func taskStatus(from localizedStatus: String) -> TaskStatus? {
        return TaskStatusBuilder().build(from: localizedStatus)
    }
    
    private func showItemPicker(with items: [TaskItemPicker], selectedItem: TaskItemPicker?, selectionHandler: @escaping (TaskItemPicker) -> Void) {
        guard items.isEmpty == false else {
            return
        }
        itemPickerView.set(items: items, selectedItem: selectedItem, selectionHandler: { [weak self] item in
            selectionHandler(item)
            self?.hideItemPicker()
        }, cancelHandler: { [weak self] in
            self?.hideItemPicker()
        })
        
        showItemPicker()
    }
    
    private func showDatePicker(with date: Date, from textField: UITextField, selectedHandler: @escaping (Date) -> Void) {
        datePickerView.set(date: date, selectionHandler: { [weak self] date in
            selectedHandler(date)
            self?.hideDatePicker()
        }, keyboardActionHandler: { [weak self, weak textField] in
            self?.hideDatePicker()
            guard let textField = textField else {
                return
            }
            self?.showCalendarKeyboard(for: textField)
        }, cancelHandler: { [weak self] in
            self?.hideDatePicker()
        })

        showDatePicker()
    }
    
    private func showCalendarKeyboard(for textField: UITextField) {
        let flexibleSpase = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let title = "Календарь"
        let calendarButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: #selector(showDatePickerFromFirstResponder))
        let toolBar = UIToolbar()
        toolBar.setItems([flexibleSpase, calendarButton], animated: false)
        toolBar.sizeToFit()

        view.endEditing(true)
        textField.inputAccessoryView = toolBar
        textField.becomeFirstResponder()
    }
    
    private func showItemPicker() {
        hidePickers()
        view.layoutIfNeeded()
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.25) {
            self.itemPickerTopConstraint?.isActive = false
            self.itemPickerBottomConstraint?.isActive = true
            
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideItemPicker() {
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2) {
            self.itemPickerTopConstraint?.isActive = true
            self.itemPickerBottomConstraint?.isActive = false
            
            self.view.layoutIfNeeded()
        }
    }
    
    private func showDatePicker() {
        hidePickers()
        view.layoutIfNeeded()
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.2) {
            self.datePickerTopConstraint?.isActive = false
            self.datePickerBottomConstraint?.isActive = true
            
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideDatePicker() {
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2) {
            self.datePickerTopConstraint?.isActive = true
            self.datePickerBottomConstraint?.isActive = false
            
            self.view.layoutIfNeeded()
        }
    }
    
    private func hidePickers() {
        hideDatePicker()
        hideItemPicker()
    }
}
