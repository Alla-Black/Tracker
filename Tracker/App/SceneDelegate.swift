import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasViewedOnboarding")
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        if hasCompletedOnboarding {
            window?.rootViewController = TabBarController()
        } else {
            let onboarding = OnboardingViewController()
            
            onboarding.onFinish = { [weak self] in
                self?.window?.rootViewController = TabBarController()
            }
             
            window?.rootViewController = onboarding
        }
        
        window?.makeKeyAndVisible()
    }

}

