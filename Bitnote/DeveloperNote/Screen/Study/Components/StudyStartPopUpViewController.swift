import UIKit

class StudyStartPopUpViewController: UIViewController {

    private var group: Group?
    private var noteList: [Note] = []
    
    convenience init(noteList: [Note],selectedGroup: Group? = nil) {
        self.init()
        self.noteList = noteList
        self.group = selectedGroup
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.view.backgroundColor = UIColor.init(white: 0.2, alpha: 0.8)
        titleLabel.text = "lesson_start_title".localized()
        messageLabel.text = "lesson_start_description".localized()
    }
    

    @objc func touchedBlankStudy() {
        if noteList.count == 0 { return }
        let vc = BlankPaperStudyNavigation(noteList, group: group)
        goStudy(vc)
        
    }
    
    @objc func touchedBlinkStudy() {
        if noteList.count == 0 { return }
        let vc = BlinkStudyNavigation(noteList)
        goStudy(vc)
    }
    
    private func goStudy(_ vc: UIViewController) {
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen

        // 현재뷰를 present 한 뷰를 찾는다
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: false) {
            pvc.present(vc, animated: false, completion: nil)
        }
    }
    
    
    @objc func touchedCancelButton() {
        self.dismiss(animated: false, completion: nil)
    }
    
    private func setupViews() {
        let buttonStack = UIStackView(arrangedSubviews: [blinkStudyButton, blankStudyButton, cancelButton])
        buttonStack.axis = .vertical
        buttonStack.alignment = .center
        buttonStack.distribution = .equalSpacing
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .center
        labelStack.distribution = .equalSpacing
        labelStack.spacing = 0
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stack = UIStackView(arrangedSubviews: [labelStack, buttonStack])
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(backgroundPanelView)
        backgroundPanelView.addSubview(stack)
        let panelViewHeight: CGFloat = 250
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
            stack.bottomAnchor.constraint(equalTo: backgroundPanelView.bottomAnchor, constant: -24),
            buttonStack.widthAnchor.constraint(equalTo: stack.widthAnchor),
            labelStack.heightAnchor.constraint(equalToConstant: 38),
            
            cancelButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.8),
            blinkStudyButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            blankStudyButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
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
    
    
    private lazy var blankStudyButton: CustomStyledButton = {
        let btn = CustomStyledButton(style: .color(UIColor(named: "main_accent")))
        btn.setTitle("lesson_writeblank_title".localized(), for: .normal)
        btn.addTarget(self, action: #selector(touchedBlankStudy), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var blinkStudyButton: CustomStyledButton = {
        let btn = CustomStyledButton(style: .color(UIColor(named: "main_accent")))
        btn.setTitle("lesson_blink_title".localized(), for: .normal)
        btn.addTarget(self, action: #selector(touchedBlinkStudy), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    private lazy var cancelButton: CustomStyledButton = {
        let btn = CustomStyledButton(style: .border(UIColor(named: "main_accent")))
        btn.setTitle("button_cancel".localized(), for: .normal)
        btn.addTarget(self, action: #selector(touchedCancelButton), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let backgroundPanelView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
}
