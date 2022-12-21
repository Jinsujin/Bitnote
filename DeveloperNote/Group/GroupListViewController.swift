//
//  GroupListViewController.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/08.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit
import GoogleMobileAds
import RxSwift
import RxCocoa


class GroupListViewController: AdsBaseViewController {
    private let viewModel = GroupListViewModel()
    private let disposeBag = DisposeBag()
    private lazy var nodataView: NoDataView = {
        let v = NoDataView(frame: self.view.frame)
        self.view.addSubview(v)
        return v
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var addGroupButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(touchedAddGroupButton))
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        tableView.delegate = self
        tableView.rowHeight = 60
        self.title = "group_title".localized()
        
        self.navigationItem.rightBarButtonItem = addGroupButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchGroupFromDB()
    }
    

    /**
     sender: 클릭한 대상 -> cell의 정보
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == NoteListViewController.identifier,
            let notelistVC = segue.destination as? NoteListViewController,
            let selectedCell = sender as? GroupListCell,
//            let selectedGroup = sender as? Group,
            let selectedIndexPath = tableView.indexPath(for: selectedCell)
        {
            let group = self.viewModel.getGroupByIndexPath(selectedIndexPath)
            let noteListViewModel = NoteListViewModel(group)
            notelistVC.viewModel = noteListViewModel
        }
    }
    
    
    @objc func touchedAddGroupButton() {
        let vc = GroupAddViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false) {
            
        }
    }
    
    private func setupBindings(){
        // table view
        viewModel.groupListOb
            .bind(to: tableView.rx.items(cellIdentifier: "groupListCell", cellType: GroupListCell.self)){ (row, element, cell) in
                cell.setViewModel(viewModel: element)
        }
        .disposed(by: disposeBag)
        
        // 뷰 모델의 데이터가 0 일때
        viewModel.groupListOb
            .map({ $0.count != 0}).bind(to: nodataView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}


extension GroupListViewController: GroupAddViewDelegate {
    func saveNewGroup(title: String) {
        self.viewModel.addNewGroup(title)
    }
    
    func editGroup(original: Group, editTitle: String) {
        self.viewModel.editGroup(original, editTitle: editTitle)
    }
}


//MARK:- UITableViewDataSource
extension GroupListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 수정
        let editAction = UIContextualAction(style: .normal, title:  "button_edit".localized(), handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(self.handleEditCategory(indexPath))
        })
        editAction.image = UIImage(systemName: "square.and.pencil")
        editAction.backgroundColor = UIColor(hex: "F9C950")

        // 삭제
        let deleteAction = UIContextualAction(style: .normal, title: "button_delete".localized()) { (action, view, success:(Bool)->Void) in
            success(self.handleDeleteCategory(indexPath))
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor(hex: "E25050")
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    
    private func handleDeleteCategory(_ indexPath: IndexPath) -> Bool {
        let deleteAlert = UIAlertController(title: "group_delete_title".localized(), message: "group_delete_alert_message".localized(), preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "button_delete".localized(), style: .destructive) { (action) in
            self.viewModel.deleteGroup(indexPath.row)
        }

        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(UIAlertAction(title: "button_cancel".localized(), style: .cancel, handler: nil))
        self.present(deleteAlert, animated: true, completion: nil)
        return true
    }
    
    /** 카테고리 이름 수정
     * 1. 데이터 모델 갱신
     * 2. DB 저장
     * 3. 테이블 뷰 갱신
     */
    private func handleEditCategory(_ indexPath: IndexPath) -> Bool {
        let selectedGroup = viewModel.getGroupByIndexPath(indexPath)
        
        let vc = GroupAddViewController(selectedGroup: selectedGroup)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
        return true
    }
}

