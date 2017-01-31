import AVFoundation
import UIKit

extension GIFCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, GIFLayoutDelegate {
    
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
   
    func collectionView(_ collectionView: UICollectionView, heightForGIFAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let GIF = viewModel.GIFAtIndexPath(indexPath)
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        
        if let w = Int(GIF.thumbnail_width), let h = Int(GIF.thumbnail_height) {
            let size = CGSize(width: w, height: h)
            let rect = AVMakeRect(aspectRatio: size, insideRect: boundingRect)
            return rect.size.height
        }
        return 100
    }
}
