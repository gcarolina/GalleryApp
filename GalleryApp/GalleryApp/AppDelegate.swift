import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = Colors.paleGrey
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.teal]
        UINavigationBar.appearance().tintColor = Colors.teal
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        
        let unsplashNetworkManager = UnsplashNetworkManager()
        let imageGalleryViewModel = ImageGalleryViewModel(networkManager: unsplashNetworkManager)
        let imageGalleryViewController = ImageGalleryViewController(galleryViewModel: imageGalleryViewModel)
        navigationController.setViewControllers([imageGalleryViewController], animated: false)

        window?.makeKeyAndVisible()
        return true
    }
}
