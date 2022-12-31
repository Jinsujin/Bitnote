import UIKit


class BlinkStudyNoteTitleView: UIView {
    convenience init(title: String, frame: CGRect) {
        self.init(frame: frame)
        titleLable.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stack = UIStackView(arrangedSubviews: [questionImg, titleLable])
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.92),
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])

        let bottomMargin: CGFloat = 8
        let start = CGPoint(x: self.bounds.minX, y: self.bounds.maxY-bottomMargin)
        let end = CGPoint(x: self.bounds.maxX, y: self.bounds.maxY-bottomMargin)
        createDashedLine(from: start, to: end, strokeLength: 4, gapLength: 4, width: 1)
    }

    
    private let questionImg: UIImageView = {
        let iv = UIImageView(image: UIImage(imageLiteralResourceName: "icon_Q"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    private let titleLable: UILabel = {
        let l = UILabel()
        l.text = "NoTitle"
        l.textAlignment = .left
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
}
