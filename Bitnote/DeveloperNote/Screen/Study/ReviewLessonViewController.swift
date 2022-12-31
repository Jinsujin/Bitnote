import UIKit
import SnapKit
import Toast_Swift


class ReviewLessonNavigationController : UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ReviewLessonViewController: AdsBaseViewController {
    @IBOutlet weak var selectedGroupTextfield: UITextField!
    @IBOutlet weak var findGroupButton: UIButton!
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var reviewLessonButton: UIButton!
    
    private var seletedGroup: Group? = nil
    private let settingConfig = SettingConfigConcrete.sharedInstance()
    
    let viewModel = ReviewLessonViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.title = "lesson_title".localized()
        findGroupButton.setTitle("lesson_find_group".localized(), for: .normal)
        startButton.title = "lesson_start".localized()
        selectedGroupTextfield.placeholder = "lesson_placeholder_select_group".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadReviewLesson()
    }
    
    private func setReviewButtonTitle(_ count: Int) {
        let str = NSLocalizedString("review_lesson_count_%d", comment: "score")
        let localizeStr = String(format: str, viewModel.getNoteList().count)
        self.reviewLessonButton.setTitle(localizeStr, for: .normal)
        count == 0
            ? (self.reviewLessonButton.isEnabled = false)
            : (self.reviewLessonButton.isEnabled = true)
    }
    
    func reloadReviewLesson() {
        let noteList = self.viewModel.getNoteList()
        setReviewButtonTitle(noteList.count)
    }
    
    
    @IBAction func goReviewLesson(_ sender: Any) {
        let noteList = viewModel.getNoteList()
        if noteList.count == 0 {
            self.view.makeToast("복습할 노트가 없습니다. \n그룹을 선택해 학습을 먼저 시작해 주세요.", duration: 3.0, position: .center)
            return
        }
        presentPopupVC(noteList)
    }
    

    @IBAction func touchedHelpButton(_ sender: Any) {
        let vc = StudyHelpPopUpViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func touchedFindGroupButton(_ sender: Any) {
        let vc = FindGroupViewController()
        vc.handleSelection = showGroup
        self.present(vc, animated: false) {
            
        }
    }
    
    @IBAction func touchedLessonstartButton(_ sender: Any) {
        guard var group = seletedGroup else {
            self.view.makeToast("lesson_message_select_group".localized(), duration: 3.0, position: .center)
            return
        }
        
        if group.notelist == nil {
            self.view.makeToast("lesson_message_nodata_note".localized(), duration: 3.0, position: .center)
            return
        }
        group.setStudyNoteList()
        if group.notelist?.count == 0 {
            self.view.makeToast("lesson_message_nodata_noteitem".localized(), duration: 3.0, position: .center)
            return
        }
        
        presentPopupVC(group.notelist!, group: group)
    }
    
    
    private func presentPopupVC(_ noteList: [Note], group: Group? = nil) {
        let vc = StudyStartPopUpViewController(noteList: noteList, selectedGroup: group)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: false) {
            self.seletedGroup = nil
            self.selectedGroupTextfield.text = nil
        }
    }
    
    
    private func showGroup(_ group: Group){
        self.selectedGroupTextfield.text = group.title
        self.seletedGroup = group
    }
}
