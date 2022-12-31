import UIKit
import RxSwift
import RxCocoa

/**
    노트 만들기
 
    - 메모 쓰기 화면
 */

// 새로운 메모 등록시
protocol NoteAddTextDelegate: class {
    func didDoneInputText(_ inputText: String)
}

class NoteAddTextViewController: UIViewController {
    weak var delegate: NoteAddTextDelegate?

    private let memoText = BehaviorRelay(value: "")
    private let disposeBag = DisposeBag()
    private var isEditMemo = false
    
    // 수정시
    var editCompletion: ((String) -> Void)?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    convenience init(memo: String){
        self.init(nibName: "NoteAddTextViewController", bundle: nil)
        self.memoText.accept(memo)
        isEditMemo = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindUI()
        navigationBar.topItem?.title = "note_item_write_title".localized()
        doneButton.title = "button_done".localized()
        closeButton.title = "button_close".localized()
    }
    
    @IBAction func touchedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func touchedDoneButton(_ sender: Any) {
        self.dismiss(animated: true){
            if self.memoText.value == "" { return }
            if self.isEditMemo {
                self.editCompletion?(self.memoText.value)
                return
            }
            self.delegate?.didDoneInputText(self.memoText.value)
        }
    }
    
    
    private func bindUI(){
        textView.text = memoText.value
        
        let textViewProperty = textView.rx.text.orEmpty
        
        textViewProperty
            .bind(to: memoText)
            .disposed(by: disposeBag)
        
        textViewProperty
            .map({ $0 != "" })
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.becomeFirstResponder()
    }
}
