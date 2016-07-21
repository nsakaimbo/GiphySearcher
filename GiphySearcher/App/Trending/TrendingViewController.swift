import FLAnimatedImage
import SDWebImage
import RxSwift
import UIKit

class GIFCollectionViewController: UIViewController {
   
    enum Configuration {
        case ShowTrending
        case ShowSearchResults(query: String)
    }
    
    var API: Networking!

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
    
    var searchTextField: UITextField = { return GIFCollectionViewController._searchTextField() }()
  
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        edgesForExtendedLayout = .Top
       
        view.backgroundColor = .whiteColor()
        
        layoutCustomViewProperties()
        
        // reactive bindings
        
        viewModel
            .updatedContents
            .subscribeNext { (updated) in
                self.collectionView.reloadData()
            }
        .addDisposableTo(rx_disposeBag)
        
        searchTextField.rx_controlEvent(.EditingDidEndOnExit)
            .subscribeNext { [weak self] in
                self?.searchTextField.resignFirstResponder()
        }
            .addDisposableTo(rx_disposeBag)
    }
   
    private func layoutCustomViewProperties() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchTextField)
        searchTextField.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 10.0).active = true
        searchTextField.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -10.0).active = true
        searchTextField.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 10.0).active = true
        searchTextField.heightAnchor.constraintEqualToConstant(64.0).active = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraintEqualToAnchor(searchTextField.bottomAnchor, constant: 40.0).active = true
        collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
    }
    
    class func _searchTextField() -> UITextField {
        let tf = UITextField()
        tf.backgroundColor = .whiteColor()
        tf.placeholder = "Search ..."
        tf.font = UIFont(name: Font.Bold, size: 40.0)
        tf.textAlignment = .Center
        tf.contentVerticalAlignment = .Center
        tf.tintColor = .blackColor()
        tf.returnKeyType = .Search
        return tf
    }
}

extension GIFCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGIFs
    }
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(GIFCollectionViewCell), forIndexPath: indexPath)
        
        if let cell = cell as? GIFCollectionViewCell {
            
            cell.downloadImage = downloadImage
            cell.cancelDownloadImage = cancelDownloadImage
            let cellViewModel = viewModel.GIFViewModelAtIndexPath(indexPath, canShowTrendingIcon: false)
            cell.setViewModel(cellViewModel)
        }
        
        return cell
    }
   
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let GIF = viewModel.GIFAtIndexPath(indexPath)
        
        if  let w = Int(GIF.thumbnail_width),
            let h = Int(GIF.thumbnail_height) {
            return CGSize(width: w, height: h)
        }
        
        return CGSize(width: 100, height: 100)
    }
   
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

extension UICollectionView {
    
    class func trendingCollectionViewWithDelegateDatasource(delegateDataSource: GIFCollectionViewController) -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        collectionView.registerClass(GIFCollectionViewCell.self, forCellWithReuseIdentifier: String(GIFCollectionViewCell))
        collectionView.backgroundColor = .clearColor()
        collectionView.dataSource = delegateDataSource
        collectionView.delegate = delegateDataSource
        collectionView.alwaysBounceVertical = true
        collectionView.allowsSelection = false
        return collectionView
    }
}
