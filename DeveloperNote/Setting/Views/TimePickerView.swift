//
//  TimePickerView.swift
//  DeveloperNote
//
//  Created by jsj on 2021/09/02.
//  Copyright © 2021 Tomatoma. All rights reserved.
//

import UIKit



class TimePickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    var minutes: Int = 0
    var seconds: Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: // min
            return 61
        case 2: // sec
            return 60
        default:
            return 1
        }
    }

    //Adjust width of each picker column
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let halfWidth = pickerView.frame.size.width / 2
        switch component {
        case 1,3: // label
            return halfWidth * 0.4
        default:
            return halfWidth * 0.6
        }
    }
  

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        switch component {
        case 1:
            let pickerLabel = UILabel()
            pickerLabel.text = "min"
            pickerLabel.textColor = UIColor.darkGray
            pickerLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
            
        case 2:
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.black
            pickerLabel.text = "\(row)"
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
            
        case 3:
            let pickerLabel = UILabel()
            pickerLabel.text = "sec"
            pickerLabel.textColor = UIColor.darkGray
            pickerLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            pickerLabel.textAlignment = NSTextAlignment.left
            return pickerLabel
            
        default:
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.black
            pickerLabel.text = "\(row)"
            pickerLabel.textAlignment = NSTextAlignment.right
            return pickerLabel
        }

    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        switch component {
//        case 0,2: // hour
//            let str = "\(row)"
//            pickerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//            return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
//        case 1: // hour label
//
//            let a = NSMutableAttributedString().bold(string: "hours", fontSize: 10)
//
//            pickerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//            return a
//        case 3: // min
//            pickerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//            return NSAttributedString(string: "min", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
//        default:
//            return nil
//        }
//    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            minutes = row
        case 2:
            seconds = row
        default:
            break
        }
    }
    
}
