import FLAnimatedImage
import SDWebImage
import RxSwift
import UIKit

final class GIFCollectionViewController: UIViewController {
   
    enum Configuration {
        case ShowTrending
        case ShowSearchResults(query: String)
        
        var endpoint: GiphyAPI {
            switch self {
            case .ShowTrending:
                return .Trending
            case let .ShowSearchResults(query):
                return .Search(query: query)
            }
        }
        
        var isShowingSearchResults:Bool {
            switch self {
            case .ShowSearchResults:
                return true
            default:
                return false
            }
        }
    }
   
    var configuration: Configuration = .ShowTrending
    
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
    
    var viewModel: ViewModelType!
    
    lazy var collectionView: UICollectionView = { return .trendingCollectionViewWithDelegateDatasource(self) } ()
    
    var searchTextField: UITextField!
    var searchQueryHeader: UILabel!
   
    private let headerHeight: CGFloat = 64.0
    private let navigationBarHeight: CGFloat = 44.0
    private let statusBarHeight: CGFloat = 20.0
    
    convenience init(configuration: Configuration) {
        self.init()
        self.configuration = configuration
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        viewModel = ViewModel(API: API, endpoint: configuration.endpoint)
        
        edgesForExtendedLayout = .Top
        view.backgroundColor = .whiteColor()
        
        // reactive bindings
        viewModel
            .updatedContents
            .subscribeNext { (updated) in
                self.collectionView.reloadData()
            }
        .addDisposableTo(rx_disposeBag)
        
        switch configuration {
            
        case .ShowTrending:
            // show search textField in trending view
            searchTextField = GIFCollectionViewController._searchTextField()
            
            searchTextField.rx_controlEvent(.EditingDidEndOnExit)
                .subscribeNext { [weak self] in
                    let query = self?.searchTextField.text
                    self?.searchTextField.resignFirstResponder()
                    let searchVC = GIFCollectionViewController(configuration: .ShowSearchResults(query: query!))
                    searchVC.API = self?.API
                    self?.navigationController?.pushViewController(searchVC, animated: true)
                }
                .addDisposableTo(rx_disposeBag)
            
        case let .ShowSearchResults(query):
            // show header
            searchQueryHeader = GIFCollectionViewController._searchQueryHeader()
            searchQueryHeader.text = "Search results for " + "\"\(query)\""
        }
        
        layoutCustomViewProperties()
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchTextField?.text = nil
    }
    
    private func layoutCustomViewProperties() {
       
        if !configuration.isShowingSearchResults {
           layoutHeader(searchTextField)
        }
        else {
            layoutHeader(searchQueryHeader)
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: headerHeight + navigationBarHeight + statusBarHeight + 40.0).active = true
        collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
    }
   
    func layoutHeader(header: UIView) {
        header.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(header)
        header.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 10.0).active = true
        header.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -10.0).active = true
        header.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 10.0).active = true
        header.heightAnchor.constraintEqualToConstant(headerHeight).active = true
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
    
    class func _searchQueryHeader() -> UILabel {
        let lbl = UILabel()
        lbl.backgroundColor = .whiteColor()
        lbl.font = UIFont(name: Font.Bold, size: 35.0)
        lbl.textAlignment = .Center
        lbl.textColor = Color.Gray.Medium
        return lbl
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
            let cellViewModel = viewModel.GIFViewModelAtIndexPath(indexPath, canShowTrendingIcon: configuration.isShowingSearchResults)
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