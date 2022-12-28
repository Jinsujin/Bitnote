//
//  LessonFinishViewController.swift
//  DeveloperNote
//
//  Created by jsj on 2021/03/18.
//  Copyright © 2021 Tomatoma. All rights reserved.
//

import UIKit
import SnapKit

class StudyFinishViewController: UIViewController {

    private var group: Group?
    private var wrongQuestionTitles = ""
    
    private var resultLabel: UILabel = {
        let l = UILabel()
        l.text = "총 -문제중 -문제를 풀었습니다."
        return l
    }()
    
    private var wrongQuestionLabel: UILabel = {
        let l = UILabel()
        l.text = ""
        l.textColor = .systemRed
        return l
    }()
    
    let viewModel = StudyFinishViewModel()
    
    convenience init(_ noteList: [Note], understandNotes: [UID: UnderstandLevel], group: Group? = nil) {
        self.init()
        
        viewModel.setData(noteList, understandNotes: understandNotes)
        
        do {
            try viewModel.updateDB { [weak self] success in
                if success {
                    self?.resultLabel.text = self?.viewModel.getResultLocalizedText()
                    self?.wrongQuestionTitles = self?.viewModel.getLowLevelTitlesText() ?? ""
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeBarButton = UIBarButtonItem(title: "button_close".localized(), style: .done, target: self, action: #selector(touchedCloseButton))
        navigationItem.setLeftBarButton(closeBarButton, animated: false)
        
        title = "lesson_finish_title".localized()
        view.backgroundColor = .white
        self.wrongQuestionLabel.text = wrongQuestionTitles
        
        let stack = UIStackView(arrangedSubviews: [resultLabel, wrongQuestionLabel])
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        
        view.addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(AppStyles.Margins.LeftRight)
            make.height.lessThanOrEqualToSuperview()
        }
    }
    
    
    @objc func touchedCloseButton (){
        if let presentingVC = self.presentingViewController,
              let controllers = (presentingVC as! RootTabBarController).viewControllers,
              let navigation = controllers[1] as? UINavigationController,
              let vc = (navigation.viewControllers[0]) as? ReviewLessonViewController {
                vc.reloadReviewLesson()
        }
        
        dismiss(animated: true)
    }
}
