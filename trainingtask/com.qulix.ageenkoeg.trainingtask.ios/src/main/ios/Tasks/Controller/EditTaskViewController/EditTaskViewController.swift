import UIKit

/**
 Данный класс отвечает за добавление и редактирование задачи
 */
class EditTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var projectTextField: UITextField!
    @IBOutlet private weak var timeToCompleteTaskTextField: UITextField!
    @IBOutlet private weak var startDateTextField: UITextField!
    @IBOutlet private weak var endDateTextField: UITextField!
    @IBOutlet private weak var statusTextField: UITextField!
    @IBOutlet private weak var taskPerformerTextField: UITextField!
    @IBOutlet private var inputViews: [UITextField]?
    
    private var projects: [Project] = []
    private var employees: [Employee] = []
    private let selectedTask: Task?
    private let selectedProject: Project?
    private let taskStatus = TaskStatus.allCases
    private let projectPickerView = UIPickerView()
    private let statusPickerView = UIPickerView()
    private let employeePickerView = UIPickerView()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let dateFormatter = DateService()
    private let settings: SettingsServise
    private let server: Server
    
    /**
     Делегат интерфейса EditTaskViewControllerDelegate
     */
    var delegate: EditTaskViewControllerDelegate?
    
    /**
     Создает экран "Редактирование задачи"
     
     - parameters:
        - selectedTask: Задача (если переход был произведен с помощью кнопки "Изменить")
        - server: Реализация интерфейса сервера
        - settings: Настройки приложения
        - selectedProject: Проект (если переход был произведен с экрана "Список проектов")
     */
    init(selectedTask: Task?, server: Server, settings: SettingsServise, selectedProject: Project?) {
        self.selectedTask = selectedTask
        self.server = server
        self.settings = settings
        self.selectedProject = selectedProject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProjects()
        getEmployees()
        setUpTitle()
        bind(selectedTask, selectedProject)
        setUpDatePicker(startDatePicker)
        setUpDatePicker(endDatePicker)
        setUpTextFieldsDelegates()
        setUpInputViews()
        setUpPickerTo(startDateTextField)
        setUpPickerTo(endDateTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTitle()
    }
    
    private func bind(_ taskModel: Task?, _ projectModel: Project?) {
        let startDate = Date()
        let endDate = dateFormatter.adjustDate(startDate, numberBetweenDates: settings.getNumberBetweenDays())
        startDateTextField.text = dateFormatter.string(for: startDate)
        endDateTextField.text = dateFormatter.string(for: endDate)
        
        if taskModel != nil {
            nameTextField.text = taskModel?.name
            projectTextField.text = taskModel?.project
            
            if let timeToComplete = taskModel?.timeToComplete {
                timeToCompleteTaskTextField.text = String(timeToComplete)
            }
            
            startDateTextField.text = dateFormatter.string(for: taskModel?.startDate)
            endDateTextField.text = dateFormatter.string(for: taskModel?.endDate)
            statusTextField.text = taskModel?.status.localizedStatus
            taskPerformerTextField.text = taskModel?.employeeName
        }
        
        if projectModel != nil {
            projectTextField.text = projectModel?.name
            projectTextField.isUserInteractionEnabled = false
        }
    }
    
    private func unbind() throws -> Task {
        guard let name = nameTextField.text, !name.isEmpty else {
            let error = "Введите наименование"
            throw AppError(message: error)
        }
        
        guard let project = projectTextField.text, !project.isEmpty else {
            let error = "Выберите проект"
            throw AppError(message: error)
        }
        
        guard projects.contains(where: {$0.name == project}) else {
            let error = "Указанный проект не существует"
            throw AppError(message: error)
        }
        
        guard let timeToCompleteString = timeToCompleteTaskTextField.text, !timeToCompleteString.isEmpty else {
            let error = "Укажите количество времени, необходимое для выполнения задачи"
            throw AppError(message: error)
        }
        
        guard let timeToComplete = Int(timeToCompleteString) else {
            let error = "Некорректный формат времени"
            throw AppError(message: error)
        }
        
        guard let startDateString = startDateTextField.text, !startDateString.isEmpty else {
            let error = "Укажите дату начала"
            throw AppError(message: error)
        }
        
        guard let endDateString = endDateTextField.text, !endDateString.isEmpty else {
            let error = "Укажите дату окончания"
            throw AppError(message: error)
        }
        
        guard let startDate = dateFormatter.date(from: startDateString) else {
            let error = "Некорректный формат даты"
            throw AppError(message: error)
        }
        
        guard let endDate = dateFormatter.date(from: endDateString) else {
            let error = "Некорректный формат даты"
            throw AppError(message: error)
        }
        
        if endDate < startDate {
            let error = "Дата начала не может быть меньше даты окончания"
            throw AppError(message: error)
        }
        
        guard let statusValue = statusTextField.text, !statusValue.isEmpty else {
            let error = "Выберите статус"
            throw AppError(message: error)
        }
        
        guard let status = TaskStatus(localizedStatus: statusValue) else {
            let error = "Указанный статус не существует"
            throw AppError(message: error)
        }
        
        let taskPerformer = taskPerformerTextField.text!
        let taskPerformerID = employees.first(where: {$0.fullName == taskPerformer})?.id
        let projectID = projects.first(where: {$0.name == project})?.id
        
        nameTextField.text = nil
        projectTextField.text = nil
        timeToCompleteTaskTextField.text = nil
        startDateTextField.text = nil
        endDateTextField.text = nil
        statusTextField.text = nil
        taskPerformerTextField.text = nil
        
        let task = Task(name: name, project: project, projectId: projectID, timeToComplete: timeToComplete,
                        startDate: startDate, endDate: endDate, status: status, employeeName: taskPerformer,
                        employeeId: taskPerformerID, id: selectedTask?.id)
        
        return task
    }
    
    private func setUpTitle() {
        let title = "Редактирование задачи"
        let topItemTitle = "Назад"
        self.title = title
        self.navigationController?.navigationBar.topItem?.title = topItemTitle
    }
    
    private func setUpProjectPicker() {
        if projects.count > 0 {
            projectTextField.inputView = projectPickerView
        }
    }
    
    private func setUpEmployeePicker() {
        if employees.count > 0 {
            taskPerformerTextField.inputView = employeePickerView
        }
    }
    
    private func setUpTextFieldsDelegates() {
        statusPickerView.dataSource = self
        statusPickerView.delegate = self
        projectPickerView.dataSource = self
        projectPickerView.delegate = self
        employeePickerView.delegate = self
        employeePickerView.dataSource = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
    }
    
    private func setUpInputViews() {
        statusTextField.inputView = statusPickerView
        startDateTextField.inputView = startDatePicker
        endDateTextField.inputView = endDatePicker
        timeToCompleteTaskTextField.keyboardType = .numberPad
        
        if selectedProject != nil {
            projectTextField.isUserInteractionEnabled = false
        }
    }
    
    private func setUpPickerTo(_ textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpase = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let title = "Клавиатура"
        let keyboardButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: #selector(didSelectShowKeyboard))
        toolBar.setItems([flexibleSpase, keyboardButton], animated: true)
        textField.inputAccessoryView = toolBar
        inputViews?.append(textField)
    }
    
    private func setUpDatePicker(_ datePicker: UIDatePicker) {
        var startDate = Date()
        var endDate = dateFormatter.adjustDate(startDate, numberBetweenDates: settings.getNumberBetweenDays())
        
        if let task = selectedTask {
            startDate = task.startDate
            endDate = task.endDate
        }
        
        datePicker.datePickerMode = .date
        datePicker.frame.size = CGSize(width: 0, height: 150)
        
        if datePicker == startDatePicker {
            datePicker.date = startDate
            datePicker.addTarget(self, action: #selector(startDateValueChanged), for: UIControl.Event.valueChanged)
        } else {
            datePicker.date = endDate
            datePicker.addTarget(self, action: #selector(endDateValueChanged), for: UIControl.Event.valueChanged)
        }
    }
    
    private func getProjects() {
        server.getProjectsWith(limit: nil, completion: { [weak self] projects in
            guard let self = self else { return }
            self.projects = projects
            self.setUpProjectPicker()
        }, error: { [weak self] error in
            self?.showAlertWith(error.localizedDescription)
        })
    }
    
    private func getEmployees() {
        server.getEmployeesWith(limit: nil, completion: { [weak self] emoloyee in
            guard let self = self else { return }
            self.employees = emoloyee
            self.setUpEmployeePicker()
        }, error: { [weak self] error in
            self?.showAlertWith(error.localizedDescription)
        })
    }
    
    /**
     Проверить валидность введенных данных
     
     - throws: Введены невалидные значения
     */
    private func checkTextFieldsForValidity() throws {
        if taskPerformerTextField.text?.isEmpty != true {
            let taskPerformer = taskPerformerTextField.text!
            guard employees.contains(where: {$0.fullName == taskPerformer}) else {
                let error = "Указанный сотрудник не существует"
                throw AppError(message: error)
            }
        }
    }
    
    @IBAction private func saveButtonAction(_ sender: Any) {
        do {
            try checkTextFieldsForValidity()
            let model = try unbind()
            delegate?.saveTask(model: model, isOpenFromAddButton: selectedTask == nil)
            self.navigationController?.popViewController(animated: true)
        } catch let error {
            showAlertWith(error.localizedDescription)
        }
    }
    
    @IBAction private func tap(_ sender: Any) {
        nameTextField.resignFirstResponder()
        projectTextField.resignFirstResponder()
        timeToCompleteTaskTextField.resignFirstResponder()
        startDateTextField.resignFirstResponder()
        endDateTextField.resignFirstResponder()
        statusTextField.resignFirstResponder()
        taskPerformerTextField.resignFirstResponder()
    }
    
    private func showAlertWith(_ message: String) {
        let alertTitle = "Ошибка"
        let actionTitle = "Ок"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func didSelectShowKeyboard() {
        inputViews?.forEach({ if $0.isFirstResponder {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let flexibleSpase = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let title = "Календарь"
            let calendarButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: #selector(didSelectShowCalendar))
            toolBar.setItems([flexibleSpase, calendarButton], animated: true)
            self.view.endEditing(true)
            $0.inputAccessoryView = toolBar
            $0.inputView = .none
            $0.keyboardType = .default
            $0.becomeFirstResponder()
        } })
    }
    
    @objc private func didSelectShowCalendar() {
        inputViews?.forEach({if $0.isFirstResponder {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let flexibleSpase = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let title = "Клавиатура"
            let keyboardButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: #selector(didSelectShowKeyboard))
            toolBar.setItems([flexibleSpase, keyboardButton], animated: true)
            self.view.endEditing(true)
            $0.inputAccessoryView = toolBar
            if $0 == startDateTextField {
                $0.inputView = startDatePicker
            } else {
                $0.inputView = endDatePicker
            }
            $0.becomeFirstResponder()
        }})
    }
    
    @objc private func startDateValueChanged(sender: UIDatePicker) {
        startDateTextField.text = dateFormatter.string(for: sender.date)
    }
    
    @objc private func endDateValueChanged(sender: UIDatePicker) {
        endDateTextField.text = dateFormatter.string(for: sender.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == projectPickerView) {
            return projects.count
            
        } else if (pickerView == statusPickerView) {
            return taskStatus.count
        } else if (pickerView == employeePickerView) {
            return employees.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == projectPickerView {
            return projects[row].name
        } else if pickerView == statusPickerView {
            return taskStatus[row].localizedStatus
        } else if pickerView == employeePickerView {
            if employees.count != 0 {
                let employee = employees[row].fullName
                return employee
            }
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == projectPickerView {
            if projects.count != 0 {
                projectTextField.text = projects[row].name
                projectTextField.resignFirstResponder()
            } else {
                return
            }
        } else if pickerView == statusPickerView {
            statusTextField.text = taskStatus[row].localizedStatus
            statusTextField.resignFirstResponder()
        } else if pickerView == employeePickerView {
            if employees.count != 0 {
                let employee = employees[row].fullName
                taskPerformerTextField.text = employee
                employeePickerView.resignFirstResponder()
                self.view.endEditing(true)
            } else {
                return
            }
        }
    }
}
