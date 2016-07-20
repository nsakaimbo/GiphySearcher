import FLAnimatedImage
import RxCocoa
import RxSwift
import NSObject_Rx
import UIKit

class GIFCollectionViewCell: UICollectionViewCell {
    
    typealias DownloadImageClosure = (url: NSURL?, imageView: FLAnimatedImageView) -> ()
    typealias CancelDownloadImageClosure = (imageView: FLAnimatedImageView) -> ()
    
    let imageView: FLAnimatedImageView = GIFCollectionViewCell._imageView()

    // TODO: add to subview
    let icon: UIImageView = GIFCollectionViewCell._icon()
    
    var downloadImage: DownloadImageClosure?
    var cancelDownloadImage: CancelDownloadImageClosure?
    var reuseBag: DisposeBag?
   
    var viewModel = PublishSubject<GIFViewModel>()
    func setViewModel(newViewModel: GIFViewModel) {
        self.viewModel.onNext(newViewModel)
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
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
        imageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        imageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
        imageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(icon)
        icon.widthAnchor.constraintEqualToConstant(20.0).active = true
        icon.heightAnchor.constraintEqualToConstant(20.0).active = true
        icon.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: -5.0).active = true
        icon.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -5.0).active = true
        
        setupSubscriptions()
    }
    
    class func _imageView() -> FLAnimatedImageView {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }
    
    class func _icon() -> UIImageView {
        let icon = UIImageView(image: UIImage(named: "TrendingIcon"))
        icon.backgroundColor = .clearColor()
        icon.tintColor = .whiteColor()
        icon.contentMode = .ScaleAspectFill
        return icon
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelDownloadImage?(imageView: imageView)
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
       
        reuseBag = DisposeBag()
        
        guard let reuseBag = reuseBag else { return }
        
        viewModel.map { (viewModel) -> NSURL? in
            return viewModel.thumbnailURL
        }.subscribeNext { [weak self] url in
            // we need an unwrapped imageView to pass to our download handler
            guard let imageView = self?.imageView else { return }
            self?.downloadImage?(url: url, imageView: imageView)
        }.addDisposableTo(reuseBag)
       
        viewModel.map { (viewModel) -> Bool in
            if let didTrend = try? viewModel.hasEverTrended.value(),
                shouldShow = try? viewModel.canShowTrendingIcon.value() {
                return !(didTrend && shouldShow)
            }
            // icon is hidden by default
            return true
        }
        .bindTo(self.icon.rx_hidden)
        .addDisposableTo(reuseBag)
    }
}
