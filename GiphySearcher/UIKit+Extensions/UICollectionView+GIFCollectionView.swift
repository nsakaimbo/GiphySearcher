import UIKit

extension UICollectionView {
    
    class func trendingCollectionViewWithDelegateDatasource(_ delegateDataSource: GIFCollectionViewController) -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.register(GIFCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: GIFCollectionViewCell.self))
        collectionView.backgroundColor = .clear
        collectionView.dataSource = delegateDataSource
        collectionView.delegate = delegateDataSource
        collectionView.alwaysBounceVertical = true
        collectionView.allowsSelection = false
        return collectionView
    }
}
