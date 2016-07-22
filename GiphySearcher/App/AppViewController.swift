import FLAnimatedImage
import UIKit

class AppViewController: UIViewController {

    var API: Networking!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .whiteColor()
        
        let imageView = FLAnimatedImageView()
        
        let image: FLAnimatedImage = {
            let url = NSBundle.mainBundle().URLForResource("dancing_abe", withExtension: "gif")
            let data = NSData(contentsOfURL: url!)
            let _image = FLAnimatedImage(animatedGIFData: data)
            return _image
        }()
       
        imageView.contentMode = .ScaleAspectFit
        imageView.animatedImage = image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.heightAnchor.constraintEqualToConstant(300).active = true
        imageView.widthAnchor.constraintEqualToConstant(300).active = true
        imageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        imageView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) { [weak self] in
            let trendingViewController = GIFCollectionViewController()
            trendingViewController.API = self?.API
            let navigationController = UINavigationController(rootViewController: trendingViewController)
            self?.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
}
