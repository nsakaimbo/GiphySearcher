import UIKit

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