import FLAnimatedImage
import SDWebImage
import UIKit

class GIFCollectionViewCell: UICollectionViewCell {
    
    typealias DownloadImageClosure = (url: NSURL, imageView: FLAnimatedImageView) -> ()
    typealias CancelDownloadImageClosure = (imageView: FLAnimatedImageView) -> ()
    
    let imageView: FLAnimatedImageView = GIFCollectionViewCell._imageView()
    var imageURL: NSURL? {
        didSet {
            // We could have used a reactive binding here but seemed like overkill.
            if let url = imageURL {
               downloadImage(url: url, imageView: imageView)
            }
            else {
                imageView.image = nil
            }
        }
    }
    
    private let downloadImage: DownloadImageClosure = { (url, imageView) in
        imageView.sd_setImageWithURL(url)
    }
    
    private let cancelDownloadImage: CancelDownloadImageClosure = { imageView in
        imageView.sd_cancelCurrentImageLoad()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        contentView.backgroundColor = .lightGrayColor()
        backgroundColor = .clearColor()
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
        imageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        imageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
        imageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
    }
    
    class func _imageView() -> FLAnimatedImageView {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelDownloadImage(imageView: imageView)

    }
}
