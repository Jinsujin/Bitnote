/*
 깜빡이 학습 루트 컨트롤러
 **/

import UIKit

class BlinkStudyNavigation: UINavigationController {
    /// 복습은 그룹정보가 없다(nil)
    convenience init(_ noteList: [Note], group: Group? = nil) {
        self.init()
        let vc = BlinkStudyRootViewController(noteList, selectedGroup: group)
        pushViewController(vc, animated: false)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BlinkStudyRootViewController: UIViewController {
    private var group: Group?
    private var noteList: [Note] = []
    private var checkUnderstandNotes: [UID: UnderstandLevel] = [:]
    
    private var currentPageIdx = 0 {
        didSet {
            let noteCount = self.noteList.count
            self.title = "\(currentPageIdx + 1) of \(noteCount)"
            if currentPageIdx >= noteCount - 1 { // 마지막 페이지일때
                barItemNextPage.title = "button_done".localized()
            } else {
                barItemNextPage.title = "button_next".localized()
            }
        }
    }
    
    private var pages = [UIViewController]()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    

    
    convenience init(_ noteList:[Note], selectedGroup: Group? = nil) {
        self.init()
        self.group = selectedGroup
        self.noteList = noteList
        self.view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentPageIdx = 0
        initPageController()
        setupNavigation()
    }
    
    
    // MARK:- Actions
    @objc func touchedNextLessonButton(){
        let noteCount = noteList.count
        if currentPageIdx >= noteCount - 1 { // last page
            goFinishPage()
        } else {
            goToNextPage()
        }
    }
    
    
    @objc func touchedCancelButton(){
        let alert = UIAlertController(title: "lesson_quit_title".localized(), message: "lesson_quit_message".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "button_ok".localized(), style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "button_cancel".localized(), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: false)
    }
    
    
    /// MARK:- Private functions
    private func convertInt_to_timeString(_ seconds: Int) -> String {
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    

    private func touchedPagesUnderstandLevelButton(_ noteid: UID, level: UnderstandLevel){
        self.checkUnderstandNotes[noteid] = level
        print(checkUnderstandNotes)
    }
    
    
    private func initPageController(){
        _ = self.noteList.compactMap {
            let vc = BlinkPageViewController($0)
            vc.handleNextPage = touchedNextLessonButton
            vc.handleUnderstandButtonTap = touchedPagesUnderstandLevelButton
            self.pages.append(vc)
        }
        
        // pageControl
        self.pageControl.numberOfPages = self.pages.count
         self.pageControl.currentPage = currentPageIdx
        
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

        self.view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
            make.right.equalTo(self.view).offset(0)
        }
    }
    
    
    private func setupNavigation(){
        self.navigationItem.setRightBarButton(barItemNextPage, animated: true)
        
        let barItemExit = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_level_low"), style: .plain, target: self, action: #selector(touchedCancelButton))
        self.navigationItem.setLeftBarButton(barItemExit, animated: false)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    private func goFinishPage() {
        let vc = StudyFinishViewController(noteList, understandNotes: checkUnderstandNotes, group: group)
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
    
}




//MARK:- PageView delegate& datasource
extension BlinkStudyRootViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
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
