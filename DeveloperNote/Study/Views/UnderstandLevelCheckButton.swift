import UIKit


class UnderstandLevelCheckButton: UIButton {
    struct LevelCheck {
        let level: UnderstandLevel
        
        var backgroundColor: UIColor {
            switch level {
            case .low:
                return UIColor(hex: "B63131")
            case .middle:
                return UIColor(hex: "E7AF22")
            case .high:
                return UIColor(hex: "31B666")
            }
        }
        
        var image: UIImage {
            switch level {
            case .low:
                return UIImage(imageLiteralResourceName: "icon_level_low")
            case .middle:
                return UIImage(imageLiteralResourceName: "icon_level_middle")
            case .high:
                return UIImage(imageLiteralResourceName: "icon_level_high")
            }
        }
        
        var description: String {
            return String(level.rawValue) + " d"
        }
    }
    
    let level: UnderstandLevel
    
    init(level: UnderstandLevel) {
        self.level = level
        super.init(frame: .zero)
        setupViews(with: .init(level: level))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(with levelCheck: LevelCheck) {
        setBackgroundColor(levelCheck.backgroundColor, for: .normal)
        setBackgroundColor(.gray, for: .selected)
        self.setTitle(levelCheck.description, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.setImage(levelCheck.image, for: .normal)
        self.alignTextBelow()
    }
}
