import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
       let window = createWindow(with: windowScene)
        window.rootViewController = makeRootViewController()
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    // MARK: - Private Methods
    
    private func createWindow(with scene: UIWindowScene) -> UIWindow {
        UIWindow(windowScene: scene)
    }
    
    private func makeRootViewController() -> UIViewController {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasViewedOnboarding")
        
        if hasCompletedOnboarding {
            return TabBarController()
        } else {
            let onboarding = OnboardingViewController()
            onboarding.onFinish = { [weak self] in
                self?.window?.rootViewController = TabBarController()
            }
            return onboarding
        }
        
    }
}

