import FLAnimatedImage
import SDWebImage
import RxSwift
import UIKit

class TrendingViewController: UIViewController {
    
    private let API = Networking()

    var downloadImage: GIFCollectionViewCell.DownloadImageClosure = { (url, imageView) in
        if let url = url {
            imageView.sd_setImageWithURL(url)
        }
        else {
            imageView.image = nil
        }
    }
    
    var cancelDownloadImage: GIFCollectionViewCell.CancelDownloadImageClosure = { imageView in
        imageView.sd_cancelCurrentImageLoad()
    }
    
    lazy var viewModel: ViewModelType = {
        return ViewModel(API: self.API, endpoint: .Trending)
    }()
    
    lazy var collectionView: UICollectionView = { return .trendingCollectionViewWithDelegateDatasource(self) } ()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 44.0).active = true
        collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
       
        // reactive bindings
        
        viewModel
            .updatedContents
            .subscribeNext { (updated) in
                self.collectionView.reloadData()
            }
        .addDisposableTo(rx_disposeBag)
    }
}

extension TrendingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGIFs
    }
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(GIFCollectionViewCell), forIndexPath: indexPath)
        
        if let cell = cell as? GIFCollectionViewCell {
            
            cell.downloadImage = downloadImage
            cell.cancelDownloadImage = cancelDownloadImage
            cell.imageURLString = viewModel.GIFAtIndexPath(indexPath).url_thumbnail
        }
        
        return cell
    }
   
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let GIF = viewModel.GIFAtIndexPath(indexPath)
        
        if  var w = Int(GIF.thumbnail_width),
            var h = Int(GIF.thumbnail_height) {
                w += 10
                h += 10
            
            return CGSize(width: w, height: h)
        }
        
        return CGSize(width: 100, height: 100)
    }
   
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 20, bottom: 0, right: 20)
    }
}

extension UICollectionView {
    
    class func trendingCollectionViewWithDelegateDatasource(delegateDataSource: TrendingViewController) -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        collectionView.registerClass(GIFCollectionViewCell.self, forCellWithReuseIdentifier: String(GIFCollectionViewCell))
        collectionView.backgroundColor = .whiteColor()
        collectionView.dataSource = delegateDataSource
        collectionView.delegate = delegateDataSource
        collectionView.alwaysBounceVertical = true
        collectionView.allowsSelection = false
        return collectionView
    }
}
