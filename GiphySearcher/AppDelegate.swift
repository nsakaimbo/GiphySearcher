import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupGlobalStyles()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {}
    
    func applicationDidEnterBackground(application: UIApplication) {}
    
    func applicationWillEnterForeground(application: UIApplication) {}
    
    func applicationDidBecomeActive(application: UIApplication) {}
    
    func applicationWillTerminate(application: UIApplication) {}
   
    func setupGlobalStyles() {
        UINavigationBar.appearance().barTintColor = .whiteColor()
        UINavigationBar.appearance().setBackgroundImage(.imageWithColor(.whiteColor()), forBarPosition: .Any, barMetrics: .Default)
        UINavigationBar.appearance().shadowImage =  .imageWithColor(.whiteColor())
    }
    
}