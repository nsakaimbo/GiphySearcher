import FLAnimatedImage
import Nuke
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
            imageView.nk_setImageWith(url)
        }
        else {
            imageView.image = nil
        }
    }
    
    var cancelDownloadImage: GIFCollectionViewCell.CancelDownloadImageClosure = { imageView in
        imageView.nk_displayImage(nil)
        imageView.nk_cancelLoading()
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
  
        edgesForExtendedLayout = .Top
        view.backgroundColor = .whiteColor()
        
        viewModel = ViewModel(API: API, endpoint: configuration.endpoint)
        
        // reactive bindings
        setViewModelSubscriptions()
        
        searchTextField = GIFCollectionViewController._searchTextField()
        
        searchTextField.rx_controlEvent(.EditingChanged)
            .subscribeNext { [weak self] in
                
                guard let query = self?.searchTextField.text,
                    let _api = self?.API else {
                        return
                }
                
                self?.configuration = query.isEmpty ? Configuration.ShowTrending : Configuration.ShowSearchResults(query: query)
                guard let endpoint = self?.configuration.endpoint else { return }
                
                self?.viewModel = ViewModel(API: _api, endpoint: endpoint)
                self?.setViewModelSubscriptions()
            }
            .addDisposableTo(rx_disposeBag)
        
        searchTextField.rx_controlEvent(.EditingDidEndOnExit)
            .subscribeNext { [weak self] in
                self?.searchTextField.resignFirstResponder()
            }
            .addDisposableTo(rx_disposeBag)
        
        layoutCustomViewProperties()
    }
   
    func setViewModelSubscriptions() {
        viewModel
            .updatedContents
            .subscribeNext { (updated) in
                self.collectionView.reloadData()
            }
            .addDisposableTo(rx_disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchTextField?.text = nil
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        ImageManager.shared.removeAllCachedImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ImageManager.shared.removeAllCachedImages() 
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
    
    override func viewDidLayoutSubviews() {
        searchTextField?.layer.addBorder(.Bottom, color: Color.Gray.Medium, thickness: 4.0)
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
        tf.autocapitalizationType = .None
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