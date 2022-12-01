import UIKit

/**
 Данный класс является вью, предназначенного для отображения дата-пикера
 */
class TaskDatePickerView: UIView {
    private let datePicker = UIDatePicker()
    private let cancelActionView = UIButton()
    private let selectActionView = UIButton()
    private let keyboardActionView = UIButton()
    private var selectionHandler: ((Date) -> Void)?
    private var keyboardActionHandler: (() -> Void)?
    private var cancelHandler: (() -> Void)?
    private var date: Date?
    
    /**
     Создает вью с дата-пикером
     */
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .lightGray
        datePicker.datePickerMode = .date
        
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Установить дата-пикер
     
     - parameters:
        - date: Дата
        - selectionHandler: Обработка действия "Выбрать"
        - cancelHandler: Обработка действия "Отмена"
     */
    func set(date: Date, selectionHandler: @escaping (Date) -> Void, keyboardActionHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
        unbind()
        bind(
            date,
            selectionHandler: selectionHandler,
            keyboardActionHandler: keyboardActionHandler,
            cancelHandler: cancelHandler
        )
    }
    
    private func layoutViews() {
        layoutKeyboardActionView()
        layoutPickerView()
        layoutCancelActionView()
        layoutSelectActionView()
    }
    
    private func layoutKeyboardActionView() {
        keyboardActionView.layer.cornerRadius = 4.0
        keyboardActionView.setTitleColor(.white, for: .normal)
        keyboardActionView.backgroundColor = .systemBlue
        keyboardActionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(keyboardActionView)
        
        NSLayoutConstraint.activate([
            keyboardActionView.widthAnchor.constraint(equalToConstant: 115.0),
            keyboardActionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            keyboardActionView.topAnchor.constraint(equalTo: topAnchor, constant: 14.0)
        ])
    }
    
    private func layoutPickerView() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: keyboardActionView.bottomAnchor, constant: 14.0),
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
            cancelActionView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 14.0),
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
            selectActionView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 14.0),
            selectActionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            selectActionView.widthAnchor.constraint(equalTo: cancelActionView.widthAnchor),
            selectActionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32.0),
        ])
    }
    
    private func bind(_ date: Date, selectionHandler: @escaping (Date) -> Void, keyboardActionHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
        self.datePicker.setDate(date, animated: true)
        self.selectionHandler = selectionHandler
        self.keyboardActionHandler = keyboardActionHandler
        self.cancelHandler = cancelHandler
        
        
        keyboardActionView.setTitle("Клавиатура", for: .normal)
        keyboardActionView.addTarget(self, action: #selector(Self.keyboardAction), for: .touchUpInside)
        cancelActionView.setTitle("Отмена", for: .normal)
        cancelActionView.addTarget(self, action: #selector(Self.cancelAction), for: .touchUpInside)
        selectActionView.setTitle("Выбрать", for: .normal)
        selectActionView.addTarget(self, action: #selector(Self.selectAction), for: .touchUpInside)
    }
    
    private func unbind() {
        self.date = nil
        selectionHandler = nil
        keyboardActionHandler = nil
        cancelHandler = nil
        
        keyboardActionView.removeTarget(self, action: nil, for: .touchUpInside)
        cancelActionView.removeTarget(self, action: nil, for: .touchUpInside)
        selectActionView.removeTarget(self, action: nil, for: .touchUpInside)
    }
    
    @objc private func keyboardAction() {
        keyboardActionHandler?()
    }
    
    @objc private func cancelAction() {
        cancelHandler?()
        unbind()
    }
    
    @objc private func selectAction() {
        let date = datePicker.date
        selectionHandler?(date)
        unbind()
    }
}
