import UIKit

class AppNavigationBar: UINavigationBar {
    struct Size {
        static let height: CGFloat = 64
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    fileprivate func commonInit() {
        self.tintColor = Color.Gray.Medium
        self.clipsToBounds = true
        self.shadowImage = UIImage.imageWithColor(UIColor.white)
        self.backgroundColor = UIColor.white
        self.isTranslucent = false
        self.isOpaque = true
        self.barTintColor = UIColor.white
        
        let bar = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 20))
        bar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        bar.backgroundColor = .black
        addSubview(bar)
    }
    
    override var intrinsicContentSize : CGSize {
        var size = super.intrinsicContentSize
        size.height = Size.height
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let navItem = topItem, let items = navItem.rightBarButtonItems {
            var x: CGFloat = frame.width - 5.5
            let width: CGFloat = 39
            
            let views = items.flatMap { $0.customView }.sorted { $0.frame.maxX > $1.frame.maxX }
            for view in views {
                x -= width
                view.frame = CGRect(
                    x: x,
                    y: view.frame.origin.y,
                    width: width,
                    height: view.frame.height
                )
            }
        }
    }
}
