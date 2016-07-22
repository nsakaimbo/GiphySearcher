import UIKit

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