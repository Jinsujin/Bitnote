//
//  NoteFloatingViewController.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/18.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

enum NoteItemType {
    case text
    case bookmark
    case photoGallery
    case drawImage
}


protocol NoteFloatingDelegate: class {
    func didTouchAddNoteItemButton(_ selectedType: NoteItemType)
}



class NoteFloatingViewController: UIViewController {
    weak var delegate: NoteFloatingDelegate?
    
    convenience init(center: CGPoint) {
        self.init()
//        print("center = ", center)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // 닫기버튼, 이미지, 텍스트, URL,이미지 그리기
    // 버튼간의 간격 = y 60
    // margin: 40
     // w, h = 60px
    
    private var closeBtnCenterYConstraint: NSLayoutConstraint!
    private var textBtnCenterY: NSLayoutConstraint!
    private var bookmarkCenterY: NSLayoutConstraint!
    private var galleryImageCenterY: NSLayoutConstraint!
    private var drawImageBtnCenterY: NSLayoutConstraint!
    
    
    public func updateCloseButtonY(center: CGPoint) {
        self.closeBtnCenterYConstraint.constant = center.y
    }
    
    private func setupViews() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.3
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        self.view.addSubview(closeButton)
        self.view.addSubview(textButton)
        self.view.addSubview(bookmarkButton)
        self.view.addSubview(drawImgButton)
        self.view.addSubview(galleryImgButton)
        
        let closeContraint = closeButton.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        closeContraint.isActive = true
        closeBtnCenterYConstraint = closeContraint
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            textButton.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor),
            bookmarkButton.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor),
            drawImgButton.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor),
            galleryImgButton.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor)
        ])
        
        let textConstraint = textButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor, constant: 0)
        textConstraint.isActive = true
        textBtnCenterY = textConstraint
        
        let bookmarkConstraint = bookmarkButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor, constant: 0)
        bookmarkConstraint.isActive = true
        bookmarkCenterY = bookmarkConstraint
        
        let drawImageConstraint = drawImgButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor, constant: 0)
        drawImageConstraint.isActive = true
        drawImageBtnCenterY = drawImageConstraint
        
        let galleryImgConstraint = galleryImgButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor, constant: 0)
        galleryImgConstraint.isActive = true
        galleryImageCenterY = galleryImgConstraint
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let parentVC = self.presentingViewController {
            if let parentVC = parentVC as? UITabBarController { // 수정
                
                // TODO: floating 버튼 bottom 위치 잡기
//                let tabBarHeight: CGFloat = parentVC.tabBar.frame.size.height
//                self.closeBtnBottomConstraint.constant = parentVC.view.safeAreaInsets.bottom + 40
                
            } else if let parentVC = parentVC as? UINavigationController { // 새로만들기
                       
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let buttonSpacing: CGFloat = 70
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.textBtnCenterY.constant = -buttonSpacing
            self.galleryImageCenterY.constant = -(buttonSpacing * 2)
            self.bookmarkCenterY.constant = -(buttonSpacing * 3)
            self.drawImageBtnCenterY.constant = -(buttonSpacing * 4)
            
            // 화면갱신 필수 요소. 시간만큼 분할되어서 애니메이션 갱신됨
            self.view.layoutIfNeeded()
            
        })
    }
    
    
    @objc func touchedAddText(_ sender: Any) {
        dismiss(animated: false) {
            self.delegate?.didTouchAddNoteItemButton(.text)
        }
    }
    
    @objc func touchedAddGalleryImage(_ sender: Any) {
        dismiss(animated: false) {
            self.delegate?.didTouchAddNoteItemButton(.photoGallery)
        }
        
    }
    
    @objc func touchedAddDrawImage(_ sender: Any) {
        dismiss(animated: false) {
            self.delegate?.didTouchAddNoteItemButton(.drawImage)
        }
    }
    
    @objc func touchedBookmarkBtn(_ sender: Any) {
        dismiss(animated: false) {
            self.delegate?.didTouchAddNoteItemButton(.bookmark)
        }
    }
    
    @objc func dismissView(_ sender: Any) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.textBtnCenterY.constant = 0
            self.galleryImageCenterY.constant = 0
            self.drawImageBtnCenterY.constant = 0
            self.bookmarkCenterY.constant = 0
            self.view.alpha = 0
            self.view.layoutIfNeeded()
            }) { (isEndAnimation) in
                self.dismiss(animated: false, completion: nil)
            }
    }
    
    
    // MARK:- UI Buttons
    private lazy var closeButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "floating button_close"), for: .normal)
        btn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var textButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "floating button_text"), for: .normal)
        btn.addTarget(self, action: #selector(touchedAddText), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "floating button_link"), for: .normal)
        btn.addTarget(self, action: #selector(touchedBookmarkBtn), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var galleryImgButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "floating button_photo"), for: .normal)
        btn.addTarget(self, action: #selector(touchedAddGalleryImage), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var drawImgButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "floating_button_drawing"), for: .normal)
        btn.addTarget(self, action: #selector(touchedAddDrawImage), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
}
