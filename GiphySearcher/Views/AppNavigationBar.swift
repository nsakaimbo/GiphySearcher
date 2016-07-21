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
    
    private func commonInit() {
        self.tintColor = Color.Gray.Medium
        self.clipsToBounds = true
        self.shadowImage = UIImage.imageWithColor(UIColor.whiteColor())
        self.backgroundColor = UIColor.whiteColor()
        self.translucent = false
        self.opaque = true
        self.barTintColor = UIColor.whiteColor()
        
        let bar = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 20))
        bar.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
        bar.backgroundColor = .blackColor()
        addSubview(bar)
    }
    
    override func intrinsicContentSize() -> CGSize {
        var size = super.intrinsicContentSize()
        size.height = Size.height
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let navItem = topItem, items = navItem.rightBarButtonItems {
            var x: CGFloat = frame.width - 5.5
            let width: CGFloat = 39
            
            let views = items.flatMap { $0.customView }.sort { $0.frame.maxX > $1.frame.maxX }
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