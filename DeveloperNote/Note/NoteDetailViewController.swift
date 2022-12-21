//
//  NoteDetailViewController.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/08.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit
import SafariServices
import Toast_Swift
import RxSwift
import RxCocoa
import Photos
import UserNotifications

/**
 
    - 텍스트 : present 뷰로 수정, 입력
    - 포토 이미지 :
    - url : present 뷰로 수정, 입력
 
 */
class NoteDetailViewController: UIViewController {
    public var completion: ((Note) -> Void)?
    public var viewModel: NoteDetailViewModel

    private let disposeBag = DisposeBag()
    private var isFocusUrlTextfield = false
    private let imagePicker = UIImagePickerController()
    private var urlConstraintBottom: NSLayoutConstraint?
    
    
    init(viewModel: NoteDetailViewModel = NoteDetailViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "contents_gray")
        
        imagePicker.delegate = self
        tableView.tableHeaderView = titleHeaderView
        titleHeaderView.titleTextfield.delegate = self
        
        setupViews()
        setNavigationBarButtonItems()
        setupBookmarkInputView()
        setGestureAndKeyboardObserver()
        requestPhotoLibraryAuth()
        setupBinding()
    }
    

    //MARK:- Actions
    @objc func touchedBookmarkDoneButton(){
        saveBookmark()
    }
    
    private func saveBookmark() {
        guard let inputText = bookmarkInputView.urlTextfield.text else {
            return
        }
        self.bookmarkInputView.urlTextfield.resignFirstResponder()
        
        if inputText == "" {
            return
        }
        
        if !verifyUrl(urlString: inputText){
            self.view.makeToast("note_item_url_not_allow".localized(), duration: 3.0, position: .center)
            return
        }
        self.viewModel.appendInputItem(NoteInputType.bookmark(inputText))
    }

        
    @objc func keyboardWillHide(noti: Notification) {
        if !isFocusUrlTextfield {
            return
        }
        
        if let notiInfo = noti.userInfo,
            let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let urlBottomConstraint = self.urlConstraintBottom {
        
//            print("keyboardFrame :\n \(keyboardFrame)")
            
            UIView.animate(withDuration: animationDuration, animations: {
                urlBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { (isHidden) in
                self.bookmarkInputView.isHidden = true
                self.bookmarkBackAreaView.isHidden = true
            }
        }
        
    }
    
    // 키보드 높이만큼, 인풋뷰 올리기
    @objc func keyboardWillShow(noti: Notification) {
        if !isFocusUrlTextfield {
            return
        }
        
        if let notiInfo = noti.userInfo,
            let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let urlBottomConstraint = self.urlConstraintBottom {
            urlBottomConstraint.constant = 0
            
            print("keyboard frame: /n\(keyboardFrame)")
            self.bookmarkInputView.isHidden = false
            self.bookmarkBackAreaView.isHidden = false
            
            // safeArea 공간만큼 높이를 빼줘야 붕 뜨지 않음
            let height = keyboardFrame.size.height //- self.view.safeAreaInsets.bottom

            UIView.animate(withDuration: animationDuration) {
                //            inputViewBottomMargin.constant = height
                urlBottomConstraint.constant -= height
                // 애니메이션 시간만큼 쪼개서 갱신. 반드시 들어가야 함
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    @objc func touchedSortButton(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    
    @objc func touchedCloseButton(_ sender: Any) {
        // 지금 열리는 화면의 컨트롤러
        // present로 열면, NavigationController
        // push는 viewController
        let presentingVC = presentingViewController is UITabBarController// UINavigationController
        
        
        // 네비게이션일때 -> present 로 염
        if presentingVC == true { //UITabBarController
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    

    
    @objc func touchedSaveButton(_ sender: Any) {
        guard let titleText = self.titleHeaderView.titleTextfield.text, titleText != "" else {
            self.view.makeToast("note_add_placeholder_title".localized(), duration: 3.0, position: .center)
            return
        }
        
        // TODO: 부모뷰에서 모델 업데이트 하기
        let savedNote = self.viewModel.saveNote()
        self.completion?(savedNote)
        let presentingVC = presentingViewController is UITabBarController
        print("IsPresentingVC? ", presentingVC)
        if presentingVC {
            self.dismiss(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @objc func urlBackgroundViewTap() {
        if !bookmarkInputView.isHidden {
            self.bookmarkInputView.urlTextfield.resignFirstResponder()
        }
    }
    
    @objc func touchedFloatingButton(_ button: UIButton) {
        let vc = NoteFloatingViewController()
        
        let center = self.view.convert(button.center, to: vc.view)
        print("button center = ", center) // 344, 617 - Edit
        // 344, 666 - New
        
        vc.updateCloseButtonY(center: center)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
    // MARK:- Private Functions
    private func requestPhotoLibraryAuth() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("allow")
            case .denied:
                print("denined")
            case .restricted, .notDetermined:
                print("not selected")
            default:
                break
            }
        }
    }
    
    /// URL 유효성 검사 - 올바른 주소값 테스트 필요
    private func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    private func setNavigationBarButtonItems() {
        navigationItem.leftBarButtonItem = self.closeButton
        navigationItem.rightBarButtonItems = [editButton,saveButton]
    }
    
    
    private func setGestureAndKeyboardObserver() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(urlBackgroundViewTap))
        bookmarkBackAreaView.addGestureRecognizer(tapGesture)
        bookmarkBackAreaView.isUserInteractionEnabled = true // 이벤트를 받도록 함

        // 키보드 올라올때 옵저버 설정
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupViews() {
        self.view.addSubview(tableView)
        self.view.addSubview(floatingButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalTo: floatingButton.widthAnchor, multiplier: 1.0),
            floatingButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            floatingButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
        ])
    }
    
    
    private func setupBinding(){
        titleHeaderView.titleTextfield.text = viewModel.initialTitleText
        
        // Input : input 값을 뷰모델 subject에 넣기
        titleHeaderView.titleTextfield.rx.text.orEmpty
            .bind(to: self.viewModel.titleText)
            .disposed(by: disposeBag)

        
        // Output : title text 필드에 값이 있을때, save 버튼 활성화
        viewModel.isTitleValid
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.title = viewModel.navigationTitle
        
        tableView.rx.itemMoved.bind(onNext: { event in
            self.viewModel.moveInputItemRowAt(from: event.sourceIndex.row, to: event.destinationIndex.row)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.bind(onNext: { event in
            self.viewModel.deleteInputItem(event.row)
            }).disposed(by: disposeBag)
        
//         tableView
        viewModel.noteInputItemsOb
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items){ (tableView, row, item) -> UITableViewCell in
                switch item {
                case .text(let textString):
                    let cell = tableView.dequeueReusableCell(withIdentifier: NoteDetailMemoCell.identifier, for: IndexPath(row: row, section: 0)) as! NoteDetailMemoCell
                    cell.memoTextView.text = textString
                    cell.touchUp = { [weak self] textString in
                        let textVC = NoteAddTextViewController(memo: textString)
                        textVC.editCompletion = { editMemo in
                            self?.viewModel.editInputTextItem(row, editText: editMemo)
                        }
                        self?.present(textVC, animated: true, completion: nil)
                        print(textString, row)
                    }
                    return cell

                case .photoGallery(let galleryImg):
                    let cell = tableView.dequeueReusableCell(withIdentifier: NoteDetailImageCell.identifier, for: IndexPath(row: row, section: 0)) as! NoteDetailImageCell
                    cell.noteImageView.image = galleryImg
                    return cell
                    
                case .drawImage(let galleryImg):
                    let cell = tableView.dequeueReusableCell(withIdentifier: NoteDetailImageCell.identifier, for: IndexPath(row: row, section: 0)) as! NoteDetailImageCell
                    cell.noteImageView.image = galleryImg
                    return cell

                case .bookmark(let bookmark):
                    let cell = tableView.dequeueReusableCell(withIdentifier: NoteDetailBookmarkCell.identifier, for: IndexPath(row: row, section: 0)) as! NoteDetailBookmarkCell
                    cell.urlLinkButton.setTitle(bookmark, for: .normal)
                    cell.touchUp = { [weak self] urlString in
                        guard let url = URL(string: urlString) else {
                            self?.view.makeToast("note_item_url_not_allow".localized(), duration: 3.0, position: .center)
                            return
                        }
                        // todo: 지원하지 않는 주소 error처리
                        let svc = SFSafariViewController(url: url)
                        self?.present(svc, animated: true, completion: nil)
                    }
                    
                    return cell
                }
        }.disposed(by: disposeBag)
    }
    
    
    private func setupBookmarkInputView() {
        bookmarkBackAreaView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bookmarkBackAreaView)
        NSLayoutConstraint.activate([
            bookmarkBackAreaView.topAnchor.constraint(equalTo: view.topAnchor),
            bookmarkBackAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarkBackAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookmarkBackAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        bookmarkBackAreaView.isHidden = true
        
        bookmarkInputView.translatesAutoresizingMaskIntoConstraints = false
        bookmarkInputView.isHidden = true
        self.view.addSubview(bookmarkInputView)
        NSLayoutConstraint.activate([
             bookmarkInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             bookmarkInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             bookmarkInputView.heightAnchor.constraint(equalToConstant: 80),
             bookmarkInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
         ])
        urlConstraintBottom = bookmarkInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        urlConstraintBottom!.isActive = true
        bookmarkInputView.urlTextfield.delegate = self
        bookmarkInputView.confirmButton.addTarget(self, action: #selector(touchedBookmarkDoneButton), for: .touchUpInside)
    }
    
    
    
    // MARK:- Private Views
    // 북마크 url주소 입력 View
    private let bookmarkInputView = BookmarkInputView()
    private lazy var bookmarkBackAreaView: UIView = {
        let v = UIView(frame: self.view.frame)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return v
    }()
    
    private lazy var saveButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "button_save".localized(), style: .plain, target: self, action: #selector(touchedSaveButton))
        return btn
    }()
    
    private lazy var editButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "button_sort".localized(), style: .plain, target: self, action: #selector(touchedSortButton))
        return btn
    }()
    
    private lazy var closeButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_arrow_left"), style: .plain, target: self, action: #selector(touchedCloseButton))
        return btn
    }()
    
    private lazy var floatingButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "floating button_write"), for: .normal)
        btn.addTarget(self, action: #selector(touchedFloatingButton(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    
    private lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero)
        tb.delegate = self
//            tableView.dataSource = self
        tb.backgroundColor = UIColor(named: "contents_gray")
        tb.separatorStyle = .none
        tb.translatesAutoresizingMaskIntoConstraints = false
        
        // 1.셀 높이 자동 설정
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 100
        
        // xib 로 셀 만들었을때 cell 등록
           // Identifier: xib-identifier
        tb.register(NoteDetailImageCell.nib(), forCellReuseIdentifier: NoteDetailImageCell.identifier)
        tb.register(NoteDetailMemoCell.nib(), forCellReuseIdentifier: NoteDetailMemoCell.identifier)
        tb.register(NoteDetailBookmarkCell.nib(), forCellReuseIdentifier: NoteDetailBookmarkCell.identifier)
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "blankCell")
        return tb
    }()
    
    private lazy var titleHeaderView: NoteDetailTitleHeaderView = {
        let v = NoteDetailTitleHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
        return v
    }()
}


// MARK:- TableView delegate & datasource
extension NoteDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = viewModel.getInputItemByIndexPath(indexPath) else {
            return UITableView.automaticDimension
        }

        switch item {
        case .photoGallery(let galleryImg):
            let ratio = galleryImg.getCropRatio()
            print(ratio)
            return tableView.frame.width / ratio
            
        case .drawImage(let img):
            let ratio = img.getCropRatio()
            print(ratio)
            return tableView.frame.width / ratio

        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.width * 0.1))

        return headerView
    }
}




/**
 MARK:- NoteFloatingDelegate
 플로팅 버튼들을 클릭했을때 액션 구현부
 */
extension NoteDetailViewController: NoteFloatingDelegate {
    func didTouchAddNoteItemButton(_ selectedType: NoteItemType) {
        switch selectedType {
        case .text:
            let textVC = NoteAddTextViewController(nibName: "NoteAddTextViewController", bundle: nil)
            textVC.delegate = self
            self.present(textVC, animated: true, completion: nil)
            break
        case .bookmark:
            bookmarkInputView.urlTextfield.becomeFirstResponder()
            break
        case .photoGallery:
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = false
                    present(imagePicker, animated: false, completion: nil)
                }
            default:
                let alert = UIAlertController(title: "note_add_image_title".localized(), message: "note_image_message_required_album".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "button_ok".localized(), style: .default) { (action) in
                    if let url = URL(string: UIApplication.openSettingsURLString){
                        if UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
                alert.addAction(okAction)
                alert.addAction(UIAlertAction(title: "button_cancel".localized(), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
            }
            break
        case .drawImage:
            let vc = NoteDrawingViewController(nibName: "NoteDrawingViewController", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            vc.touchSaveButton = { saveImage in
                self.viewModel.appendInputItem(NoteInputType.drawImage(saveImage))
            }
            self.present(vc, animated: true, completion: nil)
            break
        }
    }

}


extension NoteDetailViewController: NoteAddImageDelegate {
    func didDoneInputImage(_ image: UIImage) {
        print(image)
    }
}

// MARK:- NoteAddTextDelegate
extension NoteDetailViewController: NoteAddTextDelegate {
    func didDoneInputText(_ inputText: String) {
        print(inputText)

        viewModel.appendInputItem(NoteInputType.text(inputText))
//        self.tableView.reloadData()
    }
    
    private func updateImageItem(_ image: UIImage) {
        viewModel.appendInputItem(NoteInputType.photoGallery(image))
//        self.tableView.reloadData()
    }
}

//MARK:- ImagePickerDelegate
extension NoteDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            updateImageItem(selectedImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}



// MARK:- UITextfield delegate
extension NoteDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(bookmarkInputView.urlTextfield) {
            self.saveBookmark()
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(bookmarkInputView.urlTextfield) {
            isFocusUrlTextfield = true
        }
    }
    
    // 1
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing")
        return true
    }
    
    // 2
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(bookmarkInputView.urlTextfield) {
            textField.text = ""
        }
        isFocusUrlTextfield = false
    }
    
}


