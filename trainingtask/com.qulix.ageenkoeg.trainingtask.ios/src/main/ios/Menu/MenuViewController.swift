import UIKit

/**
 Класс основного меню, которое появляется при запуске приложения
 
 С данного экрана осуществляется переход на другие экраны приложения.
 */
class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let menuTableView = UITableView(frame: .zero, style: .plain)
    private let settingsService: SettingsServise
    private let server: Server
    
    /**
     Создает экран "Меню"
     
     - parameters:
        - settingsService: Настройки приложения
        - server: Реализация интерфейса сервера
     */
    init(settingsService: SettingsServise, server: Server) {
        self.settingsService = settingsService
        self.server = server
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTitle()
    }
    
    private func setUpTitle() {
        let title = "Главное меню"
        self.title = title
    }
    
    private func setUpTableView() {
        menuTableView.alwaysBounceVertical = false
        menuTableView.backgroundColor = .white
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        let identifier = "MenuCell"
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuTableView)
        NSLayoutConstraint.activate([
            menuTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            menuTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuTableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItem.numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "MenuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        switch MenuItem.getItem(indexPath.row) {
        case .projects:
            let title = "Проекты"
            cell.textLabel?.text = title
        case .tasks:
            let title = "Задачи"
            cell.textLabel?.text = title
        case .emoloyees:
            let title = "Сотрудники"
            cell.textLabel?.text = title
        case .settings:
            let title = "Настройки"
            cell.textLabel?.text = title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch MenuItem.getItem(indexPath.row) {
        case .projects:
            let controller = ProjectsViewController(
                server: server,
                settingsService: settingsService
            )
            self.navigationController?.pushViewController(controller, animated: true)
        case .tasks:
            let controller = TasksViewController(
                server: server,
                settingsService: settingsService,
                selectedProject: nil
            )
            self.navigationController?.pushViewController(controller, animated: true)
        case .emoloyees:
            let controller = EmployeeViewController(
                server: server,
                settingsService: settingsService
            )
            self.navigationController?.pushViewController(controller, animated: true)
        case .settings:
            let controller = SettingsViewController(
                settingsService: settingsService
            )
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

