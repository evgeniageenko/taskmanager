import UIKit

/**
 Данный класс является вью, предназначенного для отображения пикера 
 */
class TaskItemPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    private let pickerView = UIPickerView()
    private let cancelActionView = UIButton()
    private let selectActionView = UIButton()
    private var items = [TaskItemPicker]()
    private var selectionHandler: ((TaskItemPicker) -> Void)?
    private var cancelHandler: (() -> Void)?
    
    /**
     Создает вью с пикером
     */
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .lightGray
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Установить пикер
     
     - parameters:
        - items: Компоненты пикера
        - selectedItem: Выбранный компонент пикера
        - selectionHandler: Обработка действия "Выбрать"
        - cancelHandler: Обработка действия "Отмена"
     */
    func set(items: [TaskItemPicker], selectedItem: TaskItemPicker?, selectionHandler: @escaping (TaskItemPicker) -> Void, cancelHandler: @escaping () -> Void) {
        unbind()
        bind(
            items,
            selectedItem: selectedItem,
            selectionHandler: selectionHandler,
            cancelHandler: cancelHandler
        )
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].title
    }
    
    private func layoutViews() {
        layoutPickerView()
        layoutCancelActionView()
        layoutSelectActionView()
    }
    
    private func layoutPickerView() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pickerView)
        
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
    
    private func layoutCancelActionView() {
        cancelActionView.layer.cornerRadius = 4.0
        cancelActionView.setTitleColor(.white, for: .normal)
        cancelActionView.backgroundColor = .systemBlue
        cancelActionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cancelActionView)
        
        NSLayoutConstraint.activate([
            cancelActionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            cancelActionView.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 14.0),
            cancelActionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32.0),
        ])
    }
    
    private func layoutSelectActionView() {
        selectActionView.layer.cornerRadius = 4.0
        selectActionView.setTitleColor(.white, for: .normal)
        selectActionView.backgroundColor = .systemBlue
        selectActionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectActionView)
        
        NSLayoutConstraint.activate([
            selectActionView.leadingAnchor.constraint(equalTo: cancelActionView.trailingAnchor, constant: 32.0),
            selectActionView.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 14.0),
            selectActionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            selectActionView.widthAnchor.constraint(equalTo: cancelActionView.widthAnchor),
            selectActionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32.0),
        ])
    }
    
    private func bind(_ items: [TaskItemPicker], selectedItem: TaskItemPicker?,
                      selectionHandler: @escaping (TaskItemPicker) -> Void, cancelHandler: @escaping () -> Void) {
        self.items = items
        self.selectionHandler = selectionHandler
        self.cancelHandler = cancelHandler
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        cancelActionView.setTitle("Отмена", for: .normal)
        cancelActionView.addTarget(self, action: #selector(Self.cancelAction), for: .touchUpInside)
        selectActionView.setTitle("Выбрать", for: .normal)
        selectActionView.addTarget(self, action: #selector(Self.selectAction), for: .touchUpInside)

        guard let rowToSelect = items.enumerated().first(where: { $0.element.id == selectedItem?.id })?.offset else {
            return
        }
        
        pickerView.reloadAllComponents()
        pickerView.selectRow(rowToSelect, inComponent: 0, animated: false)
    }
    
    private func unbind() {
        items.removeAll()
        selectionHandler = nil
        cancelHandler = nil
        
        pickerView.dataSource = nil
        pickerView.delegate = nil
    }
    
    @objc func cancelAction() {
        cancelHandler?()
        unbind()
    }

    @objc func selectAction() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        selectionHandler?(items[selectedRow])
        unbind()
    }
}
