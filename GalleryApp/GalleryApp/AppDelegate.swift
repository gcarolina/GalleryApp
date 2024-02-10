import UIKit
import CoreData

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
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GalleryApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
