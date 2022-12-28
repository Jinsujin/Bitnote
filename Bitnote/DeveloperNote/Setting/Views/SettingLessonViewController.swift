import UIKit
import SnapKit

/*
 학습 설정
 - 백지 학습에 대한 설정
 **/



class SettingLessonViewController: UIViewController {
    enum cellType {
        case useTimer
        case setTime
        case useShuffleNote
    }

    private let cellData: [cellType] = [.useTimer, .useShuffleNote, .setTime]
    
    private let settingConfig = SettingConfigConcrete.sharedInstance()
    private lazy var isUseTimer = settingConfig.useLessonTimer
    private lazy var lessonTime_seconds = settingConfig.lessonTime_seconds
    private lazy var isUseShuffleNote = settingConfig.useShuffleNote
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "settings_study".localized()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let saveButtonItem = UIBarButtonItem(title: "button_save".localized(),
                                      style: .plain,
                                      target: self,
                                      action: #selector(touchedSaveButton))
        self.navigationItem.rightBarButtonItem = saveButtonItem
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.collectionView.addGestureRecognizer(tapGestureRecognizer)
    }


    // MARK:- Action functions
    @objc func touchedSaveButton() {
        settingConfig.useLessonTimer = self.isUseTimer
        settingConfig.lessonTime_seconds = self.lessonTime_seconds
        settingConfig.useShuffleNote = self.isUseShuffleNote
    }
    
    @objc func dismissKeyboard(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func changedTimerSwitchButton(sender: UISwitch) {
        self.isUseTimer = sender.isOn
    }
    
    
    @objc func changedShuffleSwitchButton(sender: UISwitch) {
        self.isUseShuffleNote = sender.isOn
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.register(SwitchButtonCell.nib(), forCellWithReuseIdentifier: SwitchButtonCell.reuseIdentifier)
        cv.register(SettingTimerCell.nib(), forCellWithReuseIdentifier: SettingTimerCell.reuseIdentifier)
        cv.keyboardDismissMode = .interactive
        return cv
    }()
    
}

// MARK:- SettingTimerCellDelegate
extension SettingLessonViewController: SettingTimerCellDelegate {
    func doneTimepicker(selectedSeconds: Int) {
        self.lessonTime_seconds = selectedSeconds
    }
}

//MARK:- UICollectionView delegate & datasource
extension SettingLessonViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataType = cellData[indexPath.row]
        switch dataType {
        case .useTimer:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwitchButtonCell.reuseIdentifier, for: indexPath) as? SwitchButtonCell else {
                fatalError("cannot create SwitchButtonCell")
            }
            cell.titleLabel.text = "settings_timer_use".localized()
            cell.switchButton.addTarget(self, action: #selector(changedTimerSwitchButton), for: .valueChanged)
            cell.switchButton.isOn = isUseTimer
            return cell
            
        case .useShuffleNote:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwitchButtonCell.reuseIdentifier, for: indexPath) as? SwitchButtonCell else {
                fatalError("cannot create SwitchButtonCell")
            }
            cell.titleLabel.text = "settings_shuffle_use".localized()
            cell.switchButton.addTarget(self, action: #selector(changedShuffleSwitchButton), for: .valueChanged)
            cell.switchButton.isOn = isUseShuffleNote
            return cell
            
        case .setTime:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingTimerCell.reuseIdentifier, for: indexPath) as? SettingTimerCell else {
                fatalError("cannot create SettingTimerCell")
            }
            cell.loadContents(sec: lessonTime_seconds)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}

