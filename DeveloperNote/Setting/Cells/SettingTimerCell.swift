import UIKit


protocol SettingTimerCellDelegate: class {
    func doneTimepicker(selectedSeconds: Int)
}


class SettingTimerCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: SettingTimerCell.self)
    
    weak var delegate: SettingTimerCellDelegate?
    
    private let max_seconds:Int = 3600
    private let min_default_seconds:Int = 60
    
    var seconds: Int = 0
    
    @IBOutlet weak var timeField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeExplain: UILabel!
    
    private let pickerView = TimePickerView()
    
    
    
    private let timeDoneButton : UIBarButtonItem = {
        let done = UIBarButtonItem()
        done.title = "button_done".localized()
        done.tintColor = UIColor.darkGray
        return done
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextfield()
        
        titleLabel.text = "settings_lesson_time_per_problem".localized()
        timeExplain.text = "settings_lesson_time_explain".localized()
        
        timeField.inputView = pickerView
        timeField.delegate = self
    }
    
    func loadContents(sec: Int) {
        timeField.text = sec.timeFormatString()
    }
    

    func setupTextfield(){
        let toolbar = UIToolbar()
        toolbar.barTintColor = .white
        timeField.inputAccessoryView = toolbar
        
        timeDoneButton.target = self
        timeDoneButton.action = #selector(timePikerDone(_:))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, timeDoneButton], animated: true)
        toolbar.sizeToFit()
    }
    
    // 호출 1
    @objc func timePikerDone(_ sender: Any) {
        let selectedSeconds = (self.pickerView.minutes * 60) + self.pickerView.seconds
        var adjustedSeconds: Int = selectedSeconds
        if selectedSeconds > max_seconds {
            adjustedSeconds = max_seconds
        } else if selectedSeconds < 1 { // 1초 보다 작은경우,
            adjustedSeconds = min_default_seconds
        }
        
        self.seconds = adjustedSeconds
        self.endEditing(true)
        
        self.delegate?.doneTimepicker(selectedSeconds: self.seconds)
    }

    static func nib() -> UINib {
        return UINib(nibName: String(describing: SettingTimerCell.self), bundle: nil)
    }
}


// MARK:- UITextFieldDelegate
extension SettingTimerCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" {
            textField.text = ""
        }
    }

    // 호출 2
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if seconds > max_seconds {
            textField.text = max_seconds.timeFormatString()
            return
        }
        
        textField.text = seconds.timeFormatString()
    }
    
    
    
    /// 00:00 -> seconds
    func stringToSeconds(_ timeStr: String) -> Int {
        let arr = timeStr.components(separatedBy: ":")
        
        var result: Int = 0
        
        for i in 0..<arr.count {
            guard let intVal = Int(arr[i]) else { continue }
            if (i == 0) { result += (intVal * 60) }
            else { result += intVal }
        }

        return result
    }

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard NSCharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string))else{
//            return false
//        }
//        guard let char = string.cString(using: String.Encoding.utf8) else {
//            return false
//        }
//
//        let isBackSpace = strcmp(char, "\\b")
//        if (isBackSpace != -92) { // 글자수 제한
//            if let textFieldCount = textField.text?.count, textFieldCount >= 2 {
//                return false
//            }
//        }
//        return true
//    }
}
