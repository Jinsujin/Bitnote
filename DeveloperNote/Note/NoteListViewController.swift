import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

class NoteListViewController: AdsBaseViewController {
    static let identifier = "NoteListViewController"

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: NoteListViewModel
    private let disposeBag = DisposeBag()
    private lazy var nodataView: NoDataView = {
        let v = NoDataView(frame: self.view.frame)
        // TODO: text 변경
        self.view.addSubview(v)
        return v
    }()
    
    
    init(viewModel: NoteListViewModel = NoteListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = NoteListViewModel()
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        
        navigationItem.rightBarButtonItems = [addButtonItem, deleteButtonItem]
    }
    
    
    @objc func touchedAddNoteButton() {
        let detailVC = NoteDetailViewController()
        let nav = UINavigationController(rootViewController: detailVC)
        
        // 노트 생성후, 데이터 갱신
        detailVC.completion = { note in
            self.viewModel.appendNewNote(note)
            self.view.makeToast("confirm_message_create".localized(), duration: 3.0, position: .center)
            
            // TODO: completion에서 뷰를 갱신해줘야 데이터가 반영됨
            // -> 수정가능한지 찾아보기
            self.tableView.reloadData()
        }
        self.present(nav, animated: true, completion: nil)
    }
    
    private var allowDelete = false
    
    @objc func touchedDeleteButton() {
        if allowDelete {
            self.deleteButtonItem.title = "button_delete".localized()
            tableView.setEditing(false, animated: true)
            allowDelete = false
            
            tableView.indexPathsForVisibleRows?.forEach {
                guard let cell = tableView.cellForRow(at: $0) as? NoteListCell else { return }
                cell.isEditMode = false
                cell.isEditing = false
            }
            
        } else {
            self.deleteButtonItem.title = "button_done".localized()
            tableView.setEditing(true, animated: true)
            allowDelete = true
            
            tableView.indexPathsForVisibleRows?.forEach {
                guard let cell = tableView.cellForRow(at: $0) as? NoteListCell else { return }
                cell.isEditMode = true
                cell.isEditing = true
            }
        }
    }
    
    
    private func setupBindings(){
        self.title = viewModel.groupTitle
        tableView.rowHeight = 60
        
        //tableView
        viewModel.noteListOb
            .bind(to: tableView.rx.items(
                    cellIdentifier: "noteListCell",
                    cellType: NoteListCell.self)
            ) { (row, element, cell) in
                cell.setViewModel(viewModel: element)
                cell.isEditMode = self.allowDelete
                cell.isEditing = self.allowDelete
                cell.onDelete = {
                    let deleteAlert = UIAlertController(title: "note_delete_title".localized(), message: "note_delete_alert_message".localized(), preferredStyle: .alert)
                    let deleteAction = UIAlertAction(title: "button_delete".localized(), style: .default) { (action) in
                        self.viewModel.deleteNoteFromGroup(element)
                    }
                    deleteAlert.addAction(deleteAction)
                    deleteAlert.addAction(UIAlertAction(title: "button_cancel".localized(), style: .cancel, handler: nil))
                    self.present(deleteAlert, animated: true, completion: nil)
                }
                
        }.disposed(by: disposeBag)
        
        
        // 뷰 모델의 데이터가 0 이 될때, nodataview 보이게 하기
        viewModel.noteListOb
            .map({ $0.count != 0 })
            .bind(to: nodataView.rx.isHidden)
        .disposed(by: disposeBag)
  
    }
    
    private lazy var deleteButtonItem: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "button_delete".localized(), style: .plain, target: self, action: #selector(touchedDeleteButton))
        return btn
    }()
    
    private lazy var addButtonItem: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(touchedAddNoteButton))
        return btn
    }()
}


// MARK: - UITableview datasource
extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allowDelete { return }
        guard let selectedNote = viewModel.getNoteByIndexPath(indexPath) else {
            return
        }
        
        let viewModel = NoteDetailViewModel(selectedNote)
        let vc = NoteDetailViewController(viewModel: viewModel)
        
        // 노트 생성후, 데이터 갱신
        vc.completion = { note in
            self.viewModel.editNote(note)
            self.view.makeToast("confirm_message_edit".localized(), duration: 3.0, position: .center)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneStudyAction = UIContextualAction(style: .normal, title: "note_study_finish".localized()) { (action, view, success: (Bool)-> Void) in
            success(self.handleDoneStudyNode(at: indexPath))
        }
        doneStudyAction.image = #imageLiteral(resourceName: "icon_check")
        doneStudyAction.backgroundColor = UIColor(hex: "ffe44c")
        return UISwipeActionsConfiguration(actions: [doneStudyAction])
    }
    
    private func handleDoneStudyNode(at indexPath: IndexPath) -> Bool {
        guard let selectedItem = viewModel.getNoteByIndexPath(indexPath) else { return false }
        self.viewModel.doneStudyNote(selectedItem)
        return true
    }
    
    

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    
    /// 셀이 선택되기 전에 호출되는 함수
    // 특정 cell 의 selection을 금지할때 사용
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // nil return시 선택되지 않음
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    

    /// 수정모드일때, 들여쓰기 막기위함
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
