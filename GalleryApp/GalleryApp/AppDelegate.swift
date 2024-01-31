import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = Colors.paleGrey
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colors.royalPurple]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController

        let mainViewController = GalleryViewController()
        navigationController.setViewControllers([mainViewController], animated: false)

        window?.makeKeyAndVisible()
        return true
    }
}

