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
    private let settingsService: SettingsServise
    private let server: Server
    
    /**
     Создает экран "Список сотрудников"
     
     - parameters:
        - server: Реализация интерфейса сервера
        - settingsService: Настройки приложения
     */
    init(server: Server, settingsService: SettingsServise) {
        self.server = server
        self.settingsService = settingsService
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
        let limit = settingsService.getSettings().maxNumOfEntries
        server.getEmployees(completion: { [weak self] employees in
            guard let self = self else {
                return
            }
            
            self.employees = Array(employees[0..<min(limit, employees.count)])
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
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
        let controller = EditEmployeeViewController(mode: .create)
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /**
     Изменить проект
     
     - parameters:
        - model: Сотрудник, которого необходимо изменить
     */
    func editAndSaveEmployee(model: Employee) {
        activityIndicator.startAnimating()
        server.editEmployee(model) { [weak self] in
            self?.getEmployees()
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        } error: { [weak self] error in
            self?.resolveError(error)
        }
    }
    
    /**
     Создать проект
     
     - parameters:
        - model: Сотрудник, которого необходимо создать
     */
    func createEmployee(model: EditEmployeeModel) {
        activityIndicator.startAnimating()
        server.createEmployee(model) { [weak self] employee in
            self?.getEmployees()
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
            
            let employee = self.employees[indexPath.row]
            let controller = EditEmployeeViewController(mode: .edit(employee: employee))
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
            self.tableView.reloadData()
        }
        
        let delete = swipeManager.delete(rowIndexPathAt: indexPath) { [weak self] in
            guard let self = self else {
                return
            }
            
            let id = self.employees[indexPath.row].id
            self.server.deleteEmployeeWith(id: id) { [weak self] in
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? EmployeeCell else {
            fatalError("У таблицы не зарегистрирована ячейка EmployeeCell")
        }
        let surName = employees[indexPath.row].surName
        let name = employees[indexPath.row].name
        let middleName = employees[indexPath.row].middleName
        let pisition = employees[indexPath.row].position
        cell.bind(model: EmployeeCellModel(
            surName: surName,
            name: name,
            middleName: middleName,
            position: pisition)
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch cell {
        case let employeeCell as EmployeeCell:
            employeeCell.unbind()
        default:
            break
        }
    }
}
