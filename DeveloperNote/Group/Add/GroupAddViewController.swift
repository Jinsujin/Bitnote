import UIKit

protocol GroupAddViewDelegate: AnyObject {
    func saveNewGroup(title: String)
    func editGroup(original: Group, editTitle: String)
}


class GroupAddViewController: UIViewController {
    weak var delegate: GroupAddViewDelegate?
    
    private var selectedGroup: Group?
    
    convenience init(selectedGroup: Group?) {
        self.init()
        self.selectedGroup = selectedGroup
        textField.text = selectedGroup?.title
        titleLabel.text = "group_edit_title".localized()
        saveButton.setTitle("button_edit".localized(), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.view.backgroundColor = UIColor.init(white: 0.2, alpha: 0.8)
    }
    
    @objc func touchedCancelButton() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func touchedSaveButton() {
        guard let name = self.textField.text, name != "" else {
            self.dismiss(animated: false, completion: nil)
            return
        }
        
        // 수정
        if let editGroup = selectedGroup {
           if editGroup.title == name {
                self.dismiss(animated: false, completion: nil)
                return
            }
            
            self.dismiss(animated: false) {
                self.delegate?.editGroup(original: editGroup, editTitle: name)
            }
            return
        }
        
        // 새로 만들기
        self.dismiss(animated: false) {
            self.delegate?.saveNewGroup(title: name)
        }
    }
    
    private func setupViews() {
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.distribution = .equalSpacing
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .center
        labelStack.distribution = .equalSpacing
        labelStack.spacing = 3
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stack = UIStackView(arrangedSubviews: [labelStack, textField, buttonStack])
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(backgroundPanelView)
        backgroundPanelView.addSubview(stack)
        let panelViewHeight: CGFloat = 180
        backgroundPanelView.layer.cornerRadius = panelViewHeight * 0.05
        backgroundPanelView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            backgroundPanelView.widthAnchor.constraint(equalToConstant: 270),
            backgroundPanelView.heightAnchor.constraint(equalToConstant: panelViewHeight),
            backgroundPanelView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            backgroundPanelView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -(180 * 0.3)),
            stack.widthAnchor.constraint(equalTo: backgroundPanelView.widthAnchor, multiplier: 0.9),
            stack.centerXAnchor.constraint(equalTo: backgroundPanelView.centerXAnchor),
            stack.topAnchor.constraint(equalTo: backgroundPanelView.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: backgroundPanelView.bottomAnchor, constant: -14),
            buttonStack.widthAnchor.constraint(equalTo: stack.widthAnchor),
            
            textField.widthAnchor.constraint(equalTo: stack.widthAnchor),
            cancelButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.48),
            cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1 / CustomStyledButton.RATIO),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            saveButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor)
        ])
    }
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lb.text = "group_write_title".localized()
        lb.textColor = UIColor(named:"main_accent")
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let messageLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = UIColor(hex: "8E8E8E")
        lb.text = "group_write_input_description".localized()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private lazy var cancelButton: CustomStyledButton = {
        let btn = CustomStyledButton(style: .border(UIColor(named: "main_accent")))
        btn.setTitle("button_cancel".localized(), for: .normal)
        btn.addTarget(self, action: #selector(touchedCancelButton), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var saveButton: CustomStyledButton = {
        let btn = CustomStyledButton(style: .color(UIColor(named: "main_accent")))
        btn.setTitle("button_ok".localized(), for: .normal)
        btn.addTarget(self, action: #selector(touchedSaveButton), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "group_write_input_placeholder".localized()
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let backgroundPanelView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
}
