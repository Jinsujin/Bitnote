import UIKit

class StudyHelpPopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.view.backgroundColor = UIColor.init(white: 0.2, alpha: 0.8)
        
        let dotString = "∙ "
        
        // 깜빡이 암기 학습
        messageLabelBlinkStudy.text = dotString
            + "lesson_blink_explan_label2".localized()
            + "\n"
            + dotString
            + "lesson_blink_explan_label3".localized()
        
        // 백지 학습
        messageLabelBlankPaperStudy.text = dotString
            + "lesson_writeblank_explan_label2".localized()
            + "\n"
            + dotString
            + "lesson_writeblank_explan_label3".localized()
    }

    
    @objc func touchedCancelButton() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    private func setupViews() {
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, messageLabelBlinkStudy, messageLabelBlankPaperStudy])
        labelStack.axis = .vertical
        labelStack.alignment = .center
        labelStack.distribution = .fill //.fillEqually
        labelStack.spacing = 8
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stack = UIStackView(arrangedSubviews: [labelStack, confirmButton])
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(backgroundPanelView)
        backgroundPanelView.addSubview(stack)
        
        let panelViewHeight: CGFloat = 300
        backgroundPanelView.layer.cornerRadius = panelViewHeight * 0.05
        backgroundPanelView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            backgroundPanelView.widthAnchor.constraint(equalToConstant: 350),
            backgroundPanelView.heightAnchor.constraint(equalToConstant: panelViewHeight),
            backgroundPanelView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            backgroundPanelView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -(180 * 0.3)),
            
            stack.widthAnchor.constraint(equalTo: backgroundPanelView.widthAnchor, multiplier: 0.9),
            stack.centerXAnchor.constraint(equalTo: backgroundPanelView.centerXAnchor),
            stack.topAnchor.constraint(equalTo: backgroundPanelView.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: backgroundPanelView.bottomAnchor, constant: -20),
            
            confirmButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.8),
            confirmButton.heightAnchor.constraint(equalToConstant: 40),
            
            messageLabelBlankPaperStudy.widthAnchor.constraint(equalTo: messageLabelBlinkStudy.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    
    private let backgroundPanelView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var confirmButton: CustomStyledButton = {
        let btn = CustomStyledButton(style: .border(UIColor(named: "main_accent")))
        btn.setTitle("button_close".localized(), for: .normal)
        btn.addTarget(self, action: #selector(touchedCancelButton), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lb.text = "lesson_guide_title".localized()
        lb.textColor = UIColor(named:"main_accent")
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let messageLabelBlinkStudy: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = UIColor(hex: "8E8E8E")
        lb.numberOfLines = 0
        lb.textAlignment = .left
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let messageLabelBlankPaperStudy: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = UIColor(hex: "8E8E8E")
        lb.numberOfLines = 0
        lb.textAlignment = .left
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
}
