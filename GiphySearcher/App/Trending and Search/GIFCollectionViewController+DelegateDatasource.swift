import UIKit

extension GIFCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGIFs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GIFCollectionViewCell.self), for: indexPath)
        
        if let cell = cell as? GIFCollectionViewCell {
            cell.downloadImage = downloadImage
            cell.cancelDownloadImage = cancelDownloadImage
            let cellViewModel = viewModel.GIFViewModelAtIndexPath(indexPath, canShowTrendingIcon: configuration.isShowingSearchResults)
            cell.setViewModel(cellViewModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let GIF = viewModel.GIFAtIndexPath(indexPath)
        
        if  let w = Int(GIF.thumbnail_width),
            let h = Int(GIF.thumbnail_height) {
            return CGSize(width: w, height: h)
        }
        
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
