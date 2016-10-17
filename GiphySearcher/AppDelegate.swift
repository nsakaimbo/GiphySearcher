import UIKit
import Nuke
import NukeFLAnimatedImagePlugin
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
   
    fileprivate(set) var API: Networking = Networking()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupGlobalStyles()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let appViewController = AppViewController()
        appViewController.API = API
        window?.backgroundColor = .black
        window?.rootViewController = appViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    func applicationDidBecomeActive(_ application: UIApplication) {}
    
    func applicationWillTerminate(_ application: UIApplication) {}
   
    func setupGlobalStyles() {
        
        UINavigationBar.appearance().tintColor = Color.Gray.Dark
        UINavigationBar.appearance().setBackgroundImage(.imageWithColor(.white), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage =  .imageWithColor(.white)
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: Color.Gray.Dark,
            NSFontAttributeName: UIFont(name: Font.Regular, size: 30)!
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: Color.Gray.Dark,
            NSFontAttributeName: UIFont(name: Font.Regular, size: 20)!
            ]
            , for: .normal)
    }
}
