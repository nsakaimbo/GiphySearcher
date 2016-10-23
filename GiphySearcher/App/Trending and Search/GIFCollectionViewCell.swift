import Nuke
import NukeFLAnimatedImagePlugin
import RxCocoa
import RxSwift
import NSObject_Rx
import UIKit

class GIFCollectionViewCell: UICollectionViewCell {
    
    typealias DownloadImageClosure = (_ url: URL?, _ imageView: AnimatedImageView) -> ()
    typealias CancelDownloadImageClosure = (_ imageView: AnimatedImageView) -> ()
    
    let imageView: AnimatedImageView = GIFCollectionViewCell._imageView()

    // TODO: add to subview
    let icon: UIImageView = GIFCollectionViewCell._icon()
    
    var downloadImage: DownloadImageClosure?
    var cancelDownloadImage: CancelDownloadImageClosure?
    var reuseBag: DisposeBag?
   
    var viewModel = PublishSubject<GIFViewModel>()
    func setViewModel(_ newViewModel: GIFViewModel) {
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
    
    fileprivate func setup() {
        
        contentView.backgroundColor = Color.Gray.Light
        backgroundColor = .clear
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(icon)
        icon.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        icon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0).isActive = true
        icon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0).isActive = true
        
        setupSubscriptions()
    }
    
    class func _imageView() -> AnimatedImageView {
        let imageView = AnimatedImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    class func _icon() -> UIImageView {
        let icon = UIImageView(image: UIImage(named: "TrendingIcon"))
        icon.backgroundColor = .clear
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFill
        return icon
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelDownloadImage?(imageView)
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
       
        reuseBag = DisposeBag()
        
        guard let reuseBag = reuseBag else { return }
        
        viewModel.map { (viewModel) -> URL? in
            return viewModel.thumbnailURL
        }.subscribe { [weak self] url in
            // we need an unwrapped imageView to pass to our download handler
            guard let imageView = self?.imageView else { return }
            self?.downloadImage?(url.element!!, imageView)
        }.addDisposableTo(reuseBag)
       
        viewModel.map { (viewModel) -> Bool in
            if let didTrend = try? viewModel.hasEverTrended.value(),
                let shouldShow = try? viewModel.canShowTrendingIcon.value() {
                return !(didTrend && shouldShow)
            }
            // icon is hidden by default
            return true
        }
        .bindTo(self.icon.rx.hidden)
        .addDisposableTo(reuseBag)
    }
}
