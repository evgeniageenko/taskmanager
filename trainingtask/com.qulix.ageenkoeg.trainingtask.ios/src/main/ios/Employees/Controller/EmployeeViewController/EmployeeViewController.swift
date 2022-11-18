import UIKit

/**
 Класс экрана "Список сотрудников"
 
 На этом экране отображается таблица с сотрудниками.
 */
class EmployeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditEmployeeViewControllerDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var employees: [Employee] = []
    private let refreshControl = UIRefreshControl()
    private let swipeManager = SwipeActionManager()
    private let settings: SettingsServise
    private let server: Server
    
    /**
     Создает экран "Список сотрудников"
     
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
        getEmployees()
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTitle()
    }
    
    private func setUpTitle() {
        let title = "Список сотрудников"
        let topItemTitle = "Назад"
        let backBarButtonItemTitle = "Отмена"
        let backItem = UIBarButtonItem()
        self.title = title
        self.navigationController?.navigationBar.topItem?.title = topItemTitle
        backItem.title = backBarButtonItemTitle
        navigationItem.backBarButtonItem = backItem
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = "EmployeeCell"
        let nib = UINib(nibName: nibName, bundle: nil)
        let identifier = EmployeeCell().getIdentifier()
        tableView.register(nib, forCellReuseIdentifier: identifier)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.addSubview(refreshControl)
    }
    
    private func setUpAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func getEmployees() {
        activityIndicator.startAnimating()
        let limit = settings.getLimit()
        server.getEmployeesWith(limit: limit, completion: { [weak self] emoloyee in
            guard let self = self else { return }
            self.employees = emoloyee
            self.activityIndicator.stopAnimating()
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }, error: { [weak self] error in
            self?.resolveError(error)
        })
    }
    
    /**
     Сохранить/изменить проект
     
     - parameters:
        - model: Сотрудник, которого необходимо сохранить/изменить
        - isOpenFromAddButton: Проверка - был ли произведен переход с помощью кнопки "Добавить"
     */
    func saveEmployee(model: Employee, isOpenFromAddButton: Bool) {
        if isOpenFromAddButton {
            activityIndicator.startAnimating()
            server.createEmployee(Employee(surName: model.surName,
                                           name: model.name,
                                           middleName: model.middleName,
                                           position: model.position,
                                           id: model.id)) { [weak self] employee in
                self?.getEmployees()
                self?.activityIndicator.stopAnimating()
            } error: { [weak self] error in
                self?.resolveError(error)
            }
        } else {
            activityIndicator.startAnimating()
            if let id = model.id {
                server.editEmployee(model, id: id) { [weak self] success in
                    self?.getEmployees()
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
    
    @objc private func addButtonAction(_ sender: Any) {
        let controller = EditEmployeeViewController(employee: nil)
        
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = swipeManager.edit(rowIndexPathAt: indexPath) { [weak self] in
            guard let self = self else { return }
            let employee = self.employees[indexPath.row]
            let controller = EditEmployeeViewController(employee: employee)
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
            self.tableView.reloadData()
        }
        
        let delete = swipeManager.delete(rowIndexPathAt: indexPath) { [weak self] in
            guard let self = self, let id = self.employees[indexPath.row].id else { return }
            self.server.deleteEmployeeWith(id: id) { [weak self] success in
                self?.getEmployees()
            } error: { [weak self] error in
                self?.resolveError(error)
            }
        }
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = EmployeeCell().getIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! EmployeeCell
        let surName = employees[indexPath.row].surName
        let name = employees[indexPath.row].name
        let middleName = employees[indexPath.row].middleName
        let pisition = employees[indexPath.row].position
        cell.setUpEmployeeWith(EmployeeCellModel(surName: surName,
                                                 name: name,
                                                 middleName: middleName,
                                                 position: pisition))
        return cell
    }
}
