import FLAnimatedImage
import UIKit

class AppViewController: UIViewController {

    var API: Networking!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
        
        let imageView = FLAnimatedImageView()
        
        let image: FLAnimatedImage = {
            let url = Bundle.main.url(forResource: "dancing_abe", withExtension: "gif")
            let data = try? Data(contentsOf: url!)
            let _image = FLAnimatedImage(animatedGIFData: data)
            return _image!
        }()
       
        imageView.contentMode = .scaleAspectFit
        imageView.animatedImage = image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let delay = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
            let trendingViewController = GIFCollectionViewController()
            trendingViewController.API = self?.API
            let navigationController = UINavigationController(rootViewController: trendingViewController)
            self?.present(navigationController, animated: true, completion: nil)
        }
    }
}
