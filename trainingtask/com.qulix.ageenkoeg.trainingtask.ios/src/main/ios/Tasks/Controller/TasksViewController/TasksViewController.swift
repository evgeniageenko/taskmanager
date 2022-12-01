import UIKit

/**
 Класс экрана "Список задач"
 
 На этом экране отображается таблица с задачами.
 */
class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditTaskViewControllerDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var tasks: [TaskDetailModel] = []
    private let refreshControl = UIRefreshControl()
    private let swipeManager = SwipeActionManager()
    private let selectedProject: Project?
    private let settingsService: SettingsServise
    private let server: Server
    
    /**
     Создает экран "Список задач"
     
     - parameters:
        - server: Реализация интерфейса сервера
        - settingsService: Настройки приложения
        - selectedProject: Выбранный проект (если переход был осуществлен с экрана "Проекты")
     */
    init(server: Server, settingsService: SettingsServise, selectedProject: Project?) {
        self.server = server
        self.settingsService = settingsService
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
    
    private func setUpAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func loadData() {
        guard let project = selectedProject else {
            return getTasks()
        }
        getTaskFor(project: project)
    }
    
    private func getTaskFor(project: Project) {
        let id = project.id
        activityIndicator.startAnimating()
        let limit = settingsService.getSettings().maxNumOfEntries
        server.getProjectTasksBy(id: id) { [weak self] tasks in
            guard let self = self else {
                return
            }
            
            self.tasks = Array(tasks[0..<min(limit, tasks.count)])
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        } error: { [weak self] error in
            self?.resolveError(error)
        }
    }
    
    private func getTasks() {
        activityIndicator.startAnimating()
        let limit = settingsService.getSettings().maxNumOfEntries
        server.getTasks(completion: { [weak self] tasks in
            guard let self = self else {
                return
            }
            
            self.tasks = Array(tasks[0..<min(limit, tasks.count)])
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }, error: { [weak self] error in
            self?.resolveError(error)
        })
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
    
    @objc private func addButtonAction(_ sender: Any) {
        let controller = EditTaskViewController(
            mode: .create(project: selectedProject, canEditProject:  checkIsCanEditProject()),
            server: server,
            settingsService: settingsService
        )
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func checkIsCanEditProject() -> Bool {
        guard selectedProject != nil else {
            return false
        }
        return true
    }
    
    /**
     Изменить задачу
     
     - parameters:
        - model: Задача, которую необходимо изменить
     */
    func editAndSaveTask(model: Task) {
        activityIndicator.startAnimating()
        server.editTask(model) { [weak self] in
            self?.loadData()
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        } error: { [weak self] error in
            self?.resolveError(error)
        }
    }
    
    /**
     Создать задачу
     
     - parameters:
        - model: Задача, которую необходимо создать
     */
    func createTask(model: EditTaskModel) {
        activityIndicator.startAnimating()
        server.createTask(model) { [weak self] task in
            self?.loadData()
            self?.activityIndicator.stopAnimating()
        } error: { [weak self] error in
            self?.resolveError(error)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = swipeManager.edit(rowIndexPathAt: indexPath) { [weak self] in
            guard let self = self else {
                return
            }
            
            let task = self.tasks[indexPath.row]
            let controller = EditTaskViewController(
                mode: .edit(task: task),
                server: self.server,
                settingsService: self.settingsService
            )
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
            self.tableView.reloadData()
        }
        
        let delete = swipeManager.delete(rowIndexPathAt: indexPath) { [weak self] in
            guard let self = self else {
                return
            }
            
            let id = self.tasks[indexPath.row].task.id
            self.server.deleteTaskWith(id: id) { [weak self] in
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskCell else {
            fatalError("У таблицы не зарегистрирована ячейка TaskCell")
        }
        
        let name = tasks[indexPath.row].task.name
        let project = tasks[indexPath.row].project.name
        let status = tasks[indexPath.row].task.status
        cell.bind(model: TaskCellModel(
            name: name,
            projectName: project,
            status: status,
            isOpenFromProjectVC: checkIsCanEditProject())
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch cell {
        case let taskCell as TaskCell:
            taskCell.unbind()
        default:
            break
        }
    }
}

