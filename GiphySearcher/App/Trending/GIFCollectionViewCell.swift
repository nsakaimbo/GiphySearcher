import FLAnimatedImage
import Haneke
import UIKit

class GIFCollectionViewCell: UICollectionViewCell {
    
    typealias DownloadImageClosure = (url: NSURL, imageView: FLAnimatedImageView) -> ()
    typealias CancelDownloadImageClosure = (imageView: FLAnimatedImageView) -> ()
    
    let imageView: FLAnimatedImageView = GIFCollectionViewCell._imageView()
    var imageURL: NSURL? {
        didSet {
            if let url = imageURL {
               downloadImage(url: url, imageView: imageView)
            }
        }
    }
    
    private let downloadImage: DownloadImageClosure = { (url, imageView) in
        
        let cache = Shared.dataCache
        
        let image = cache.fetch(URL: url).onSuccess { data in
            
            if url.pathExtension == ".gif" {
                let image = FLAnimatedImage(animatedGIFData: data)
               
                dispatch_async(dispatch_get_main_queue()) {
                    imageView.animatedImage = image
                }
                
            }
            else {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }
    }
    
//    private let cancelDownloadImage: CancelDownloadImageClosure = { imageView in
//        
//    }
    
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
       
//        imageView.frame = self.frame
//        imageView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
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
//        cancelDownloadImage(imageView: imageView)
//        imageView.animatedImage = nil
//        imageView.image = nil
    }
}
