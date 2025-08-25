import UIKit
import CoreData
import FirebaseCore
import Amplitude
import AppMetricaCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        if ConfStorage.shared.conf.defaultUnit == .unknow {
            onFirstLaunch()
        }

        configurePurchase()

        if AppEnvironment.current == .appStore {
            configureFirebase()
            configureAmplitude()
            configureAppMetrica()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "SportApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
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

    private func configurePurchase() {
        // hidden
    }

    private func configureFirebase() {
        // hidden
    }

    private func configureAmplitude() {
        // hidden
    }

    private func configureAppMetrica() {
        // hidden
    }

    private func onFirstLaunch() {
        // Default unit
        var conf = ConfStorage.shared.conf

        if Locale.current.region?.identifier == "US" {
            conf.defaultUnit  = .imperial
        } else {
            conf.defaultUnit  = .metric
        }

        ConfStorage.shared.updateConfiguration(conf)

        // Template
        let workoutStorage = WorkoutStorage.shared

        Template.gymStart.workouts.forEach { workout in
            workoutStorage.addWorkoutFromTempl(workout)
        }

        Template.homeStart.workouts.forEach { workout in
            workoutStorage.addWorkoutFromTempl(workout)
        }
    }
}
