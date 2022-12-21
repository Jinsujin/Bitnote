import UIKit
import SnapKit


class BlankPaperStudyNavigation: UINavigationController {
    convenience init(_ noteList: [Note], group: Group?) {
        self.init()
        let vc = BlankPaperStudyRootViewController(noteList, selectedGroup: group)
        pushViewController(vc, animated: false)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BlankPaperStudyRootViewController: UIViewController  {
    ////////////////// timer //////////////
    private var timer = Timer()
    private lazy var timerView = TimerCountView(frame: view.frame)
    private var secondsRemaining = SettingConfigConcrete.sharedInstance().lessonTime_seconds
    private let config_isUseTimer = SettingConfigConcrete.sharedInstance().useLessonTimer
    private let config_maxLessonSecond = SettingConfigConcrete.sharedInstance().lessonTime_seconds
    
    private var group: Group?
    private var noteList: [Note] = []
    private var checkUnderstandNotes: [UID: UnderstandLevel] = [:]

    private var currentPageIdx = 0 {
        didSet {
            let noteCount = self.noteList.count
            self.title = "\(currentPageIdx + 1) of \(noteCount)"
//            self.lessonCountLabel.text = "\(currentPageIdx + 1) of \(noteCount)"
            if currentPageIdx >= noteCount - 1 { // 마지막 페이지일때
                barItemNextPage.title = "button_done".localized()
            } else {
                barItemNextPage.title = "button_next".localized()
            }
        }
    }
    
    private var pages = [UIViewController]()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    private let pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .black
        pc.tintColor = UIColor.gray
        return pc
    }()
    
    
    // 다음버튼 - 마지막 페이지 일때 "헉습끝내기" 버튼
    private lazy var barItemNextPage: UIBarButtonItem = {
        let b = UIBarButtonItem(title: "button_next".localized(),
                                      style: .plain,
                                      target: self,
                                      action: #selector(touchedNextLessonButton))
        return b
    }()
    
    
    convenience init(_ noteList: [Note], selectedGroup: Group? = nil) {
        self.init()
        self.group = selectedGroup
        self.noteList = noteList
        self.view.backgroundColor = .white
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentPageIdx = 0
        initPageController()
        setupNavigationItems()
        
        // 타이머 설정일때만 타이머 활성화
        if config_isUseTimer {
            self.timerView.updateViews(config_maxLessonSecond)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
        }
    }

    
    // MARK:- Actions
    @objc func touchedNextLessonButton(){
        let noteCount = self.noteList.count
        if currentPageIdx >= noteCount - 1 { // last page
            self.timer.invalidate()
            goFinishPage()
        } else {
            secondsRemaining = self.config_maxLessonSecond
            goToNextPage()
        }
    }
    
    
    @objc func touchedCancelButton(){
        let alert = UIAlertController(title: "lesson_quit_title".localized(), message: "lesson_quit_message".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "button_ok".localized(), style: .default) { _ in
            if self.config_isUseTimer {
                self.timer.invalidate()
            }
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "button_cancel".localized(), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: false)
    }
    
    
    @objc func updateCounter() {
        // 마지막 페이지에서 타이머가 다됬다면, 타이머 제거
        if self.secondsRemaining <= 0
            && self.currentPageIdx >= self.noteList.count - 1 {
            self.timer.invalidate()
            goFinishPage()
            return
        }
        // 시간다됬을때, 다음페이지로 이동하고 타임초기화
        if self.secondsRemaining <= 0 {
            goToNextPage()
            secondsRemaining = self.config_maxLessonSecond
            self.timerView.updateViews(config_maxLessonSecond, percent: 1.0)
            return
        }
        self.secondsRemaining -= 1
        self.timerView.updateViews(secondsRemaining, percent: calculateCurrentPercent())
    }
    
    
    
    /// MARK:- Private functions
    private func touchedPagesUnderstandLevelButton(_ noteid: UID, level: UnderstandLevel){
        self.checkUnderstandNotes[noteid] = level
        print(checkUnderstandNotes)
    }
    
    
    /// 타이머 퍼센트 계산
    private func calculateCurrentPercent() -> CGFloat {
        return CGFloat(secondsRemaining) / CGFloat(config_maxLessonSecond)
    }
    
    
    private func initPageController(){
        _ = self.noteList.compactMap {
            let vc = BlankPaperPageViewController($0)
            vc.handleUnderstandButtonTap = touchedPagesUnderstandLevelButton
            self.pages.append(vc)
        }

        // pageControl
        self.pageControl.numberOfPages = self.pages.count
         self.pageControl.currentPage = currentPageIdx
//         self.view.addSubview(self.pageControl)
//
//        pageControl.snp.makeConstraints { make -> Void in
//            make.bottom.equalTo(self.view).offset(-20)
//            make.centerX.equalTo(self.view)
//            make.height.equalTo(20)
//            make.width.equalTo(self.view).offset(-20)
//        }
        
        pageViewController.setViewControllers([pages[currentPageIdx]], direction: .forward, animated: true, completion: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.didMove(toParent: self)
        // pageview scroll gesture remove
        for view in self.pageViewController.view.subviews {
            guard let subview = view as? UIScrollView else {
                return
            }
            subview.isScrollEnabled = false
        }
        
        // top view //
        self.view.addSubview(timerView)
        timerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.width.equalTo(self.view)
//            make.height.equalTo(50)
        }
        let timerViewHeightConstraint = timerView.heightAnchor.constraint(equalToConstant: 50)
        timerViewHeightConstraint.isActive = true
        
        if config_isUseTimer {
            timerView.isHidden = false
        } else {
            timerView.isHidden = true
            timerViewHeightConstraint.constant = 0
        }
        
        self.view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(timerView.snp.bottom).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
            make.right.equalTo(self.view).offset(0)
        }
    }
    
    
    private func setupNavigationItems(){
        self.navigationItem.setRightBarButton(barItemNextPage, animated: true)
        
        let barItemExit = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_level_low"), style: .plain, target: self, action: #selector(touchedCancelButton))
        self.navigationItem.setLeftBarButton(barItemExit, animated: false)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    private func goFinishPage() {
        let vc = StudyFinishViewController(self.noteList, understandNotes: self.checkUnderstandNotes, group: self.group)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 다음페이지 이동
    private func goToNextPage(){
        let currentViewController = self.pages[self.currentPageIdx]
        guard let nextViewcontroller = self.pageViewController( pageViewController, viewControllerAfter: currentViewController)
            else{ return }
        pageViewController.setViewControllers([nextViewcontroller], direction: .forward, animated: true, completion: nil)
        self.currentPageIdx += 1
    }
    
    /// 이전 페이지 이동
    private func goToPreviousPage(currentPageIndex : Int){
        let currentViewController = self.pages[currentPageIndex]
        guard let previousViewController =  self.pageViewController(pageViewController, viewControllerBefore: currentViewController) else { return }
        pageViewController.setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
    }
}




//MARK:- PageView delegate& datasource
extension BlankPaperStudyRootViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 { // 첫페이지 왔을때
                // wrap to last page in array
                print(" before : pages.last")
                return self.pages.last
            } else {
                // 이전 페이지 이동
                print("before : -1")
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 { // 다음페이지로 이동시
                // go to next page in array
                print("after : +1")
                return self.pages[viewControllerIndex + 1]
            } else {
                // 마지막 페이지에 왔을때.
                // 계속 루프 돌릴려면 여기서 return pages.first
                print("after: pages.first")

                return nil
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // set the pageControl.currentPage to the index of the current viewController in pages
            if let viewControllers = pageViewController.viewControllers {
                if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                    print("pagecontrol currentpage \(viewControllerIndex)")
                    self.pageControl.currentPage = viewControllerIndex
                    self.currentPageIdx = viewControllerIndex
                }
            }
    }
}
