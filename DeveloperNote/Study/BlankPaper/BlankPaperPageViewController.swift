/*
    백지 학습 - 각 문제 페이지
 
 **/


import UIKit

class BlankPaperPageViewController: UIViewController {
    
    public var handleUnderstandButtonTap: ((UID, UnderstandLevel) -> Void)?

    var noteData: Note = Note.init(title: "", inputItems: [])
    private var understandingLevel: UnderstandLevel = .high
    
    
    convenience init(_ note: Note){
        self.init()
        self.noteData = note
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        titleLabel.text = noteData.title
    
        setupViews()
    }
    
    // MARK:- Action Functions
    @objc func touchedLevelButton(sender: UnderstandLevelCheckButton) {
        self.understandingLevel = sender.level
        handleUnderstandButtonTap?(noteData.id, sender.level)
    }
    
    
    private func setupViews(){
        view.backgroundColor = UIColor(hex: "F4F5F6")
        
        let contentsStack = UIStackView(arrangedSubviews: [questionImg, titleLabel])
        contentsStack.alignment = .center
        contentsStack.axis = .horizontal
        contentsStack.distribution = .fillProportionally
        contentsStack.spacing = 12
        
        let levelButtonsStack = UIStackView(arrangedSubviews: [lowLevelButton, middleLevelButton, highLevelButton])
        levelButtonsStack.axis = .horizontal
        levelButtonsStack.spacing = 0
        levelButtonsStack.distribution = .fillEqually

        
        self.view.addSubview(levelButtonsStack)
        self.view.addSubview(pannelView)
        pannelView.addSubview(contentsStack)
        
        
        levelButtonsStack.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(60)
        }
        
        pannelView.snp.makeConstraints { (make) in
            make.bottom.equalTo(levelButtonsStack.snp.top).offset(-18)
            make.top.equalTo(self.view).offset(40)
            make.width.equalTo(self.view).multipliedBy(0.9)
            make.centerX.equalTo(self.view)
        }
        
        contentsStack.snp.makeConstraints { (make) in
            make.center.equalTo(pannelView)
            make.width.equalTo(pannelView).multipliedBy(0.9)
        }
        
        questionImg.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(20)
        }

        pannelView.layer.cornerRadius = 20
        pannelView.layer.masksToBounds = true
    }

    private var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "NoTitle"
        l.textAlignment = .left
        return l
    }()
    
    
    private let questionImg: UIImageView = {
        let iv = UIImageView(image: UIImage(imageLiteralResourceName: "icon_Q"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    private let pannelView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var lowLevelButton: UnderstandLevelCheckButton = {
        let btn = UnderstandLevelCheckButton(level: .low)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(touchedLevelButton), for: .touchUpInside)
        return btn
    }()

    private let middleLevelButton: UnderstandLevelCheckButton = {
        let btn = UnderstandLevelCheckButton(level: .middle)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(touchedLevelButton), for: .touchUpInside)
        return btn
    }()
    
    private let highLevelButton: UnderstandLevelCheckButton = {
        let btn = UnderstandLevelCheckButton(level: .high)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(touchedLevelButton), for: .touchUpInside)
        return btn
    }()
}
