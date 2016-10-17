import FLAnimatedImage
import Nuke
import RxCocoa
import RxSwift
import UIKit

final class GIFCollectionViewController: UIViewController {
   
    enum Configuration {
        case showTrending
        case showSearchResults(query: String)
        
        var endpoint: GiphyAPI {
            switch self {
            case .showTrending:
                return .trending
            case let .showSearchResults(query):
                return .search(query: query)
            }
        }
        
        var isShowingSearchResults:Bool {
            switch self {
            case .showSearchResults:
                return true
            default:
                return false
            }
        }
    }
   
    var configuration: Configuration = .showTrending
    
    var API: Networking!

    var downloadImage: GIFCollectionViewCell.DownloadImageClosure = { (url, imageView) in
        if let url = url {
            Nuke.loadImage(with: url, into: imageView)
        }
        else {
            imageView.image = nil
        }
    }
    
    // From the Nuke docs: "Nuke.loadImage(with:into:) method cancels previous outstanding request associated with the target. No need to implement prepareForReuse"
    // Note 10/17/16: Explicitly canceling the download may be unecessary with the updated implementation as noted above.
    var cancelDownloadImage: GIFCollectionViewCell.CancelDownloadImageClosure = { imageView in
        Nuke.cancelRequest(for: imageView)
    }
    
    var viewModel: ViewModelType!
    
    lazy var collectionView: UICollectionView = { return .trendingCollectionViewWithDelegateDatasource(self) } ()
    
    var searchTextField: UITextField!
    var searchQueryHeader: UILabel!
   
    fileprivate let headerHeight: CGFloat = 64.0
    fileprivate let navigationBarHeight: CGFloat = 44.0
    fileprivate let statusBarHeight: CGFloat = 20.0
    
    convenience init(configuration: Configuration) {
        self.init()
        self.configuration = configuration
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .top
        view.backgroundColor = .white
        
        viewModel = ViewModel(API: API, endpoint: configuration.endpoint)
        
        // reactive bindings
        setViewModelSubscriptions()
        
        searchTextField = GIFCollectionViewController._searchTextField()
        
        searchTextField
            .rx
            .text
            .throttle(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                
                guard let query = $0, !query.isEmpty else {
                    self.configuration = Configuration.showTrending
                    return
                }
                
                self.configuration = Configuration.showSearchResults(query: query)
                self.viewModel = ViewModel(API: self.API, endpoint: self.configuration.endpoint)
                self.setViewModelSubscriptions()
                
            })
            .addDisposableTo(rx_disposeBag)
        
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: {
                self.searchTextField.resignFirstResponder()
            })
            .addDisposableTo(rx_disposeBag)
        
        layoutCustomViewProperties()
    }

    func setViewModelSubscriptions() {
        viewModel
            .updatedContents
            .subscribe { (updated) in
                self.collectionView.reloadData()
            }
            .addDisposableTo(rx_disposeBag)
    }

    /// Validates search query text.
    /// Returns `true` if text is non-nil and non-empty
    fileprivate func validate(_ text: String?) -> Bool {
        
        if let text = text,
            !text.isEmpty {
            return true
        }
        
        return false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextField?.text = nil
    }
    
    fileprivate func layoutCustomViewProperties() {
       
        searchQueryHeader = type(of:self)._searchQueryHeader()
        
        if !configuration.isShowingSearchResults {
           layoutHeader(searchTextField)
        }
        else {
            layoutHeader(searchQueryHeader)
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight + navigationBarHeight + statusBarHeight + 40.0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
   
    func layoutHeader(_ header: UIView) {
        header.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(header)
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0).isActive = true
        header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0).isActive = true
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0).isActive = true
        header.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        searchTextField?.layer.addBorder(.bottom, color: Color.Gray.Medium, thickness: 4.0)
    }
    
    class func _searchTextField() -> UITextField {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Search ..."
        tf.font = UIFont(name: Font.Bold, size: 40.0)
        tf.textAlignment = .center
        tf.contentVerticalAlignment = .center
        tf.tintColor = .black
        tf.returnKeyType = .search
        tf.autocapitalizationType = .none
        return tf
    }
    
    class func _searchQueryHeader() -> UILabel {
        let lbl = UILabel()
        lbl.backgroundColor = .white
        lbl.font = UIFont(name: Font.Bold, size: 35.0)
        lbl.textAlignment = .center
        lbl.textColor = Color.Gray.Medium
        return lbl
    }
}
