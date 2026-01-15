import UIKit
import CoreData

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerCoreDataModel")
        container.loadPersistentStores(completionHandler: {( storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Store Setup
    
    lazy var trackerStore: TrackerStoreProtocol = {
        let context = persistentContainer.viewContext
        return TrackerStore(context: context)
    }()
    
    lazy var trackerRecordStore: TrackerRecordStoreProtocol = {
        let context = persistentContainer.viewContext
        return TrackerRecordStore(context: context)
    }()
    
    lazy var trackerCategoryStore: TrackerCategoryStoreProtocol = {
        let context = persistentContainer.viewContext
        return TrackerCategoryStore(context: context)
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        WeekdayValueTransformer.register()
        ColorValueTransformer.register()
        
        AnalyticsService.activate()
        
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

