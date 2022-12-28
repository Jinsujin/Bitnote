import UIKit


class TimerCountView: UIView {
    private var barWidthConstraint: NSLayoutConstraint!
    private var superViewFrame: CGRect!
    
    
    /// percent: 1.0 ~ 0.0
    public func updateViews(_ seconds: Int, percent: CGFloat = 1.0) {
        self.timerLabel.text = seconds.timeFormatString()
        barWidthConstraint.constant = superViewFrame.width * percent
    }
    
    private let timerLabel: UILabel = {
        let l = UILabel()
        l.text = "00:00"
        l.textAlignment = .center
        return l
    }()
    
    private let barView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "font_sub")
        v.layer.cornerRadius = 5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let barBackgroundView: UIView = {
        let v = UIView()
//        v.backgroundColor = UIColor(named: "tableView_line")
        return v
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.superViewFrame = frame
        setupViews(frame)
    }
    
    
    required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    private func setupViews(_ superViewFrame: CGRect) {
        let barHeight = 10
        
        self.backgroundColor = UIColor(named: "tableView_line")
        
        self.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(-barHeight/2)
            make.centerX.equalTo(self)
        }
        
        self.addSubview(barBackgroundView)
        barBackgroundView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(barHeight)
        }

        self.addSubview(barView)
        barView.snp.makeConstraints { (make) in
            make.right.equalTo(barBackgroundView)
            make.top.equalTo(barBackgroundView)
            make.height.equalTo(barHeight)
        }
        print("timerCountView: ", superViewFrame.width)
        barWidthConstraint = barView.widthAnchor.constraint(equalToConstant: superViewFrame.width)
        barWidthConstraint.isActive = true
    }
}
