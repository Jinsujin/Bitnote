/*
    백지 학습 - 깜빡이 학습이 문제 페이지
 
    - 타이머 사용여부 설정값과는 별개로, 무조건 타이머 동작
 **/


import UIKit


class BlinkPageViewController: UIViewController {

    /// 타이머가 끝났을떄, 다음 페이지 호출
    public var handleNextPage: (()-> Void)?
    public var handleUnderstandButtonTap: ((UID, UnderstandLevel) -> Void)?
    
    /** timer **/
    private var timer = Timer()
    private lazy var timerView = TimerCountView(frame: view.frame)
    private var secondsRemaining = SettingConfigConcrete.sharedInstance().lessonTime_seconds
    private let config_isUseTimer = SettingConfigConcrete.sharedInstance().useLessonTimer
    private let config_maxLessonSecond = SettingConfigConcrete.sharedInstance().lessonTime_seconds
    
    var noteData: Note = Note.init(title: "", inputItems: [])
    
    
    /// 이해버튼 누르지 않고, 다음버튼으로 페이지 넘어갔을때는 .high 로 간주
    private var understandingLevel: UnderstandLevel = .high
    

    convenience init(_ note: Note) {
        self.init()
        
        self.noteData = note
//        self.noteData.inputItems = note.inputItems.filter({ $0.keyString != "bookmark" })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        tableView.tableHeaderView = titleHeaderView
        
        // 타이머 설정일때만 타이머 활성화
        //        if config_isUseTimer {
        self.timerView.updateViews(config_maxLessonSecond)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        RunLoop.current.add(timer, forMode: .common)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    
    // MARK:- Action Functions
    @objc func touchedLevelButton(sender: UnderstandLevelCheckButton) {
        self.understandingLevel = sender.level
        handleUnderstandButtonTap?(noteData.id, sender.level)
    }
    
    
    @objc func updateCounter() {
        // 시간이 다 됬고, 마지막 노트 내용을 보여주고 있다면
        if self.secondsRemaining <= 0
            && self.noteData.inputItems.count <= 1 {
            self.timer.invalidate()
            // 부모 페이지 컨트롤러 에서 다음 페이지로 이동
            handleNextPage?()
            return
        }
        
        // 시간다됬을때, 다음페이지로 이동하고 타임초기화
        if self.secondsRemaining <= 0 {
            // 다음 셀 보여주기
            removeCurrentVisibleCell()
            secondsRemaining = self.config_maxLessonSecond
            self.timerView.updateViews(config_maxLessonSecond, percent: 1.0)
            return
        }
        self.secondsRemaining -= 1
        self.timerView.updateViews(secondsRemaining, percent: calculateCurrentPercent())
    }
    

    /// MARK:- Private functions
    private func removeCurrentVisibleCell(){
        self.noteData.inputItems.remove(at: 0)
        self.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
    

    /// 타이머 퍼센트 계산
    private func calculateCurrentPercent() -> CGFloat {
        return CGFloat(secondsRemaining) / CGFloat(config_maxLessonSecond)
    }
    
    
    // MARK:- VIEWS
    private let pannelView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero)
        tb.delegate = self
        tb.dataSource = self
        tb.register(NoteDetailImageCell.nib(), forCellReuseIdentifier: NoteDetailImageCell.identifier)
        tb.register(NoteDetailMemoCell.nib(), forCellReuseIdentifier: NoteDetailMemoCell.identifier)
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "blankCell")
        tb.separatorStyle = .none // 라인 삭제
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    private lazy var titleHeaderView: BlinkStudyNoteTitleView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
        let v = BlinkStudyNoteTitleView(title: self.noteData.title, frame: frame)
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

    private func setupViews() {
        view.backgroundColor = UIColor(hex: "F4F5F6")
        timerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(timerView)
        self.view.addSubview(pannelView)
        pannelView.addSubview(tableView)
        
        let levelButtonsStack = UIStackView(arrangedSubviews: [lowLevelButton, middleLevelButton, highLevelButton])
        levelButtonsStack.axis = .horizontal
        levelButtonsStack.spacing = 0
        levelButtonsStack.distribution = .fillEqually
        levelButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(levelButtonsStack)
        
        NSLayoutConstraint.activate([
            timerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            timerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            timerView.heightAnchor.constraint(equalToConstant: 50),
            timerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),

            levelButtonsStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            levelButtonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            levelButtonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            levelButtonsStack.heightAnchor.constraint(equalToConstant: 60),
            
            pannelView.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 40),
            pannelView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            pannelView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pannelView.bottomAnchor.constraint(equalTo: levelButtonsStack.topAnchor, constant: -18),
            
            
            tableView.topAnchor.constraint(equalTo: pannelView.topAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: pannelView.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: pannelView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: pannelView.trailingAnchor, constant: -20)
        ])
        pannelView.layer.cornerRadius = 20
        pannelView.layer.masksToBounds = true
    }
}



// MARK:- UITableViewDataSource
extension BlinkPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteData.inputItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.noteData.inputItems[indexPath.row]
        switch item {
        case .text(let textString):
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteDetailMemoCell.identifier, for: indexPath) as! NoteDetailMemoCell
            cell.memoTextView.text = textString
            return cell
            
        case .photoGallery(let img), .drawImage(let img):
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteDetailImageCell.identifier, for: indexPath) as! NoteDetailImageCell
            cell.noteImageView.image = img
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell", for: indexPath)
            return cell
        }
    }
}

// MARK:- UITableViewDelegate
extension BlinkPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 0 {
            return 0.0
        }
        
        let item = self.noteData.inputItems[indexPath.row]
        switch item {
        case .photoGallery(let img), .drawImage(let img):
            let ratio = img.getCropRatio()
            return tableView.frame.width / ratio
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}


