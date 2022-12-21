import UIKit


class CustomStyledButton: UIButton {
    static let RATIO: CGFloat = 112/40
    
    struct CustomStyleButton {
        enum Style {
            case color(UIColor?)
            case border(UIColor?)
        }
        let style: Style
        
        var backgroundColor: UIColor {
            switch style {
            case .color(let c):
                return c ?? UIColor.init(named: "main_accent") ?? UIColor.black
            case .border:
                return UIColor.white
            }
        }
        var fontColor: UIColor {
            switch style {
            case .color:
                return .white
            case .border(let c):
                return c ?? UIColor.black
            }
        }
    }

    init(style: CustomStyleButton.Style) {
        super.init(frame: .zero)
        setupViews(with: .init(style: style))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 여기서 frame size 를 받아올 수 있다.
        self.layer.cornerRadius = self.frame.size.height * 0.08
    }
    
    private func setupViews(with style: CustomStyleButton) {
        clipsToBounds = true
        self.backgroundColor = style.backgroundColor
        self.setTitleColor(style.fontColor, for: .normal)
        
        switch style.style {
        case .color:
            break
        case .border(let c):
            self.layer.borderWidth = 0.8
            self.layer.borderColor = c?.cgColor
        }
    }
}


