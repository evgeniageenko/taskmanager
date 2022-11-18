import UIKit

/**
 Класс экрана "Список проектов"
 
 На этом экране отображается таблица с проектами.
 */
class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditProjectViewControllerDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var projects: [Project] = []
    private let refreshControl = UIRefreshControl()
    private let swipeManager = SwipeActionManager()
    private let settings: SettingsServise
    private let server: Server
    
    /**
     Создает экран "Список проектов"
     
     - parameters:
        - server: Реализация интерфейса сервера
        - settings: Настройки приложения
     */
    init(server: Server, settings: SettingsServise) {
        self.server = server
        self.settings = settings
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
        getProjects()
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTitle()
    }
    
    private func setUpTitle() {
        let title = "Список проектов"
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
        let nibName = "ProjectCell"
        let nib = UINib(nibName: nibName, bundle: nil)
        let identifier = ProjectCell().getIdentifier()
        tableView.register(nib, forCellReuseIdentifier: identifier)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.addSubview(refreshControl)
    }
    
    private func setUpAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = addButton
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
    
    private func getProjects() {
        activityIndicator.startAnimating()
        let limit = settings.getLimit()
        server.getProjectsWith(limit: limit, completion: { [weak self] projects in
            guard let self = self else { return }
            self.projects = projects
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            self.activityIndicator.stopAnimating()
        }, error: { [weak self] error in
            self?.resolveError(error)
        })
    }
    
    /**
     Сохранить/изменить проект
     
     - parameters:
        - model: Проект, который необходимо сохранить/изменить
        - isOpenFromAddButton: Проверка - был ли произведен переход с помощью кнопки "Добавить"
     */
    func saveProject(model: Project, isOpenFromAddButton: Bool) {
        if isOpenFromAddButton {
            activityIndicator.startAnimating()
            server.createProject(Project(name: model.name,
                                         description: model.description,
                                         tasks: model.tasks,
                                         id: model.id)) { [weak self] project in
                self?.getProjects()
                self?.activityIndicator.stopAnimating()
            } error: { [weak self] error in
                self?.resolveError(error)
            }
        } else {
            activityIndicator.startAnimating()
            if let id = model.id {
                server.editProject(model, id: id) { [weak self] success in
                    self?.getProjects()
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
    
    @objc private func refresh(_ sender: AnyObject) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc private func addButtonAction(_ sender: Any) {
        let controller = EditProjectViewController(project: nil)
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = swipeManager.edit(rowIndexPathAt: indexPath) { [weak self] in
            guard let self = self else { return }
            let project = self.projects[indexPath.row]
            let controller = EditProjectViewController(project: project)
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
            self.tableView.reloadData()
        }
        
        let delete = swipeManager.delete(rowIndexPathAt: indexPath) { [weak self] in
            guard let self = self, let id = self.projects[indexPath.row].id else { return }
            self.server.deleteProjectWith(id: id) { [weak self] success in
                self?.getProjects()
            } error: { [weak self] error in
                self?.resolveError(error)
            }
        }
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = ProjectCell().getIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ProjectCell
        let name = projects[indexPath.row].name
        let description = projects[indexPath.row].description
        cell.setUpProjectWith(ProjectCellModel(name: name,
                                               description: description))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProject = projects[indexPath.item]
        let controller = TasksViewController(server: server,
                                             settings: settings,
                                             selectedProject: selectedProject)
        let title = "Назад"
        self.navigationItem.backBarButtonItem?.title = title
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
