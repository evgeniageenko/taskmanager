import UIKit

/**
 Класс экрана "Список задач"
 
 На этом экране отображается таблица с задачами.
 */
class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditTaskViewControllerDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var tasks: [Task] = []
    private var isOpenFromProjectVC = false
    private let refreshControl = UIRefreshControl()
    private let swipeManager = SwipeActionManager()
    private let selectedProject: Project?
    private let settings: SettingsServise
    private let server: Server
    
    /**
     Создает экран "Список задач"
     
     - parameters:
        - server: Реализация интерфейса сервера
        - settings: Настройки приложения
        - selectedProject: Выбранный проект на экране "Проекты"
     */
    init(server: Server, settings: SettingsServise, selectedProject: Project?) {
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
        setUpTableView()
        setUpAddButton()
        setUpTitle()
        loadData()
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTitle()
    }
    
    private func setUpTitle() {
        let title = "Список задач"
        let topItemTitle = "Назад"
        let backBarButtonItemTitle = "Отмена"
        let backItem = UIBarButtonItem()
        self.title = title
        self.navigationController?.navigationBar.topItem?.title = topItemTitle
        backItem.title = backBarButtonItemTitle
        navigationItem.backBarButtonItem = backItem
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let nibName = "TaskCell"
        let nib = UINib(nibName: nibName, bundle: nil)
        let identifier = TaskCell().getIdentifier()
        tableView.register(nib, forCellReuseIdentifier: identifier)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.addSubview(refreshControl)
    }
    
    private func loadData() {
        if selectedProject != nil {
            getSelectedProjectTasks()
        } else {
            getTasks()
        }
    }
    
    private func getSelectedProjectTasks() {
        if let id = selectedProject?.id {
            activityIndicator.startAnimating()
            let limit = settings.getLimit()
            server.getProjectTasksBy(id: id, limit: limit) { [weak self] tasks in
                guard let self = self else { return }
                self.tasks = tasks
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
                self.activityIndicator.stopAnimating()
            } error: { [weak self] error in
                self?.resolveError(error)
            }
        }
    }
    
    private func getTasks() {
        activityIndicator.startAnimating()
        let limit = settings.getLimit()
        server.getTasksWith(limit: limit, completion: { [weak self] tasks in
            guard let self = self else { return }
            self.tasks = tasks
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            self.activityIndicator.stopAnimating()
        }, error: { [weak self] error in
            self?.resolveError(error)
        })
    }
    
    /**
     Сохранить/изменить задачу
     
     - parameters:
        - model: Задача, которую необходимо сохранить/изменить
        - isOpenFromAddButton: Проверка - был ли произведен переход с помощью кнопки "Добавить"
     */
    func saveTask(model: Task, isOpenFromAddButton: Bool) {
        if isOpenFromAddButton {
            activityIndicator.startAnimating()
            server.createTask(Task(name: model.name,
                                   project: model.project,
                                   projectId: model.projectId,
                                   timeToComplete: model.timeToComplete,
                                   startDate: model.startDate,
                                   endDate: model.endDate,
                                   status: model.status,
                                   employeeName: model.employeeName,
                                   employeeId: model.employeeId,
                                   id: model.id)) { [weak self] task in
                self?.loadData()
                self?.activityIndicator.stopAnimating()
            } error: { [weak self] error in
                self?.resolveError(error)
            }
        } else {
            activityIndicator.startAnimating()
            if let id = model.id {
                server.editTask(model, id: id) { [weak self] success in
                    self?.loadData()
                    self?.activityIndicator.stopAnimating()
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                } error: { [weak self] error in
                    self?.resolveError(error)
                }
            }
        }
    }
    
    private func showAlertWith(_ message: String) {
        let alertTitle = "Ошибка"
        let actionTitle = "Ок"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func resolveError(_ error: Error) {
        activityIndicator.stopAnimating()
        showAlertWith(error.localizedDescription)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func setUpAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonAction(_ sender: Any) {
        let controller = EditTaskViewController(selectedTask: nil,
                                                server: server,
                                                settings: settings,
                                                selectedProject: selectedProject)
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = swipeManager.edit(rowIndexPathAt: indexPath) { [weak self] in
            guard let self = self else { return }
            let task = self.tasks[indexPath.row]
            let controller = EditTaskViewController(selectedTask: task,
                                                    server: self.server,
                                                    settings: self.settings,
                                                    selectedProject: self.selectedProject)
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
            self.tableView.reloadData()
        }
        
        let delete = swipeManager.delete(rowIndexPathAt: indexPath) { [weak self] in
            guard let self = self, let id = self.tasks[indexPath.row].id else { return }
            self.server.deleteTaskWith(id: id) { [weak self] success in
                self?.getTasks()
            } error: { [weak self] error in
                self?.resolveError(error)
            }
        }
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = TaskCell().getIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TaskCell
        let name = tasks[indexPath.row].name
        let project = tasks[indexPath.row].project
        let status = tasks[indexPath.row].status
        if selectedProject != nil {
            isOpenFromProjectVC = true
        } else {
            isOpenFromProjectVC = false
        }
        cell.setUpTaskWith(TaskCellModel(name: name,
                                         projectName: project,
                                         status: status,
                                         isOpenFromProjectVC: isOpenFromProjectVC))
        return cell
    }
}

