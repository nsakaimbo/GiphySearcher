import UIKit
import RxSwift
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
   
    private(set) var API: Networking = Networking()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupGlobalStyles()
      
        let cache = SDImageCache.sharedImageCache()
        cache.clearDisk()
        // cache optimizations for RAM
        // reference: https://github.com/rs/SDWebImage/issues/1544
        cache.shouldCacheImagesInMemory = false
        cache.shouldDecompressImages = false
        SDWebImageDownloader.sharedDownloader().shouldDecompressImages = false
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let trendingViewController = GIFCollectionViewController()
        trendingViewController.API = API
        let navigationController = UINavigationController(rootViewController: trendingViewController)
        window?.backgroundColor = .blackColor()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {}
    
    func applicationDidEnterBackground(application: UIApplication) {}
    
    func applicationWillEnterForeground(application: UIApplication) {}
    
    func applicationDidBecomeActive(application: UIApplication) {}
    
    func applicationWillTerminate(application: UIApplication) {}
   
    func setupGlobalStyles() {
        UINavigationBar.appearance().barTintColor = .blackColor()
        UINavigationBar.appearance().setBackgroundImage(.imageWithColor(.whiteColor()), forBarPosition: .Any, barMetrics: .Default)
        UINavigationBar.appearance().shadowImage =  .imageWithColor(.whiteColor())
    }
    
}