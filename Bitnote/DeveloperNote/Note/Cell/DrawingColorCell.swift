//
//  DrawingColorCell.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/26.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class DrawingColorCell: UICollectionViewCell {
    
    static let identifier = "DrawingColorCell"
    var shouldTintWhenSelected = true
    
    @IBOutlet weak var circelView: UIView!
    
    override var isSelected: Bool {
        willSet {
            onSelected(newValue)
        }
    }
    
    
    override var isHighlighted: Bool {
      willSet {
        animate(isHighlighted: newValue)
      }
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let CircleLayer   = CAShapeLayer()
        let circleRadius = circelView.frame.width / 2
        let center = CGPoint(x: circleRadius, y: circleRadius)
        let circlePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: CGFloat(CGFloat.pi), endAngle: CGFloat(CGFloat.pi * 4), clockwise: true)
           CircleLayer.path = circlePath.cgPath
          CircleLayer.strokeColor = UIColor.white.cgColor
        CircleLayer.fillColor = self.backgroundColor?.cgColor
           CircleLayer.lineWidth = 4
           CircleLayer.strokeStart = 0
           CircleLayer.strokeEnd  = 1
        circelView.layer.addSublayer(CircleLayer)
        
        circelView.isHidden = true
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.masksToBounds = false
        contentView.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib()-> UINib {
        return UINib(nibName: "DrawingColorCell", bundle: nil)
    }
    


   //MARK:- Private functions
    private func onSelected(_ newValue: Bool) {
         guard selectedBackgroundView == nil else { return }
         if shouldTintWhenSelected {
            self.circelView.isHidden = !newValue
         }
     }
    
   private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
       let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
       if isHighlighted {
           UIView.animate(withDuration: 0.5,
                          delay: 0,
                          usingSpringWithDamping: 1,
                          initialSpringVelocity: 0,
                          options: animationOptions, animations: {
                           self.transform = .init(scaleX: 0.8, y: 0.8)
           }, completion: completion)
       } else {
           UIView.animate(withDuration: 0.5,
                          delay: 0,
                          usingSpringWithDamping: 1,
                          initialSpringVelocity: 0,
                          options: animationOptions, animations: {
                           self.transform = .identity
           }, completion: completion)
       }
   }

}
