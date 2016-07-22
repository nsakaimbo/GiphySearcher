import UIKit
import Nuke
import NukeAnimatedImagePlugin
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
   
    private(set) var API: Networking = Networking()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupGlobalStyles()
      
        let decoder = ImageDecoderComposition(decoders: [AnimatedImageDecoder(), ImageDecoder()])
        let loader = ImageLoader(configuration: ImageLoaderConfiguration(dataLoader: ImageDataLoader(), decoder: decoder), delegate: AnimatedImageLoaderDelegate())
        let cache = AnimatedImageMemoryCache()
        ImageManager.shared = ImageManager(configuration: ImageManagerConfiguration(loader: loader, cache: cache))
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let appViewController = AppViewController()
        appViewController.API = API
        window?.backgroundColor = .blackColor()
        window?.rootViewController = appViewController
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