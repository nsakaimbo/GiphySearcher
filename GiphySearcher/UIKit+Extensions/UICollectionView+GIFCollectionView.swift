import UIKit

extension UICollectionView {
    
    class func trendingCollectionViewWithDelegateDatasource(_ delegateDataSource: GIFCollectionViewController) -> UICollectionView {
        
        let layout = GIFLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(GIFCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: GIFCollectionViewCell.self))
        collectionView.backgroundColor = .clear
        collectionView.dataSource = delegateDataSource
        collectionView.delegate = delegateDataSource
        collectionView.alwaysBounceVertical = true
        collectionView.allowsSelection = false
        return collectionView
    }
}

protocol GIFLayoutDelegate: class {
    
    func collectionView(_ collectionView:UICollectionView, heightForGIFAtIndexPath indexPath:IndexPath,
                        withWidth width:CGFloat) -> CGFloat
}

final class GIFLayout: UICollectionViewLayout {
    
    weak var delegate: GIFLayoutDelegate!
   
    func resetAttributesCache() {
        cache.removeAll()
    }
    
    private var numberOfColumns: Int = 2
    private var cellPadding: CGFloat = 6.0
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return (collectionView!.bounds.width - insets.left + insets.right)
    }
    
    override func prepare() {
        
        guard let collectionView = collectionView, cache.isEmpty else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth )
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let width = columnWidth - cellPadding * 2
            let itemHeight = delegate.collectionView(collectionView, heightForGIFAtIndexPath: indexPath,
                                                      withWidth:width)
            let height = cellPadding +  itemHeight + cellPadding
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column >= (numberOfColumns - 1) ? 0 : column+1
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
}
