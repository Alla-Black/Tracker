import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupViewControllers() {
        let trackersVC = makeTrackersTab()
        let statisticsVC = makeStatisticsTab()
        viewControllers = [trackersVC, statisticsVC]
    }
    
    private func makeTrackersTab() -> UIViewController {
        let vc = TrackersViewController()
        vc.tabBarItem = UITabBarItem(
            title: AppStrings.MainTab.tabTrackersTitle,
            image: UIImage(resource: .trackersButton),
            selectedImage: nil
        )
        return vc
    }
    
    private func makeStatisticsTab() -> UIViewController {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure("AppDelegate is missing")
            return UIViewController()
        }
        
        let recordStore = appDelegate.trackerRecordStore
        let provider = StatisticsProvider(recordStore: recordStore)
        let viewModel = StatisticsViewModel(statisticsProvider: provider)
        let vc = StatisticsViewController(viewModel: viewModel)
        
        vc.tabBarItem = UITabBarItem(
            title: AppStrings.MainTab.tabStatisticsTitle,
            image: UIImage(resource: .statisticButton),
            selectedImage: nil
        )
        return vc
    }
    
    private func setupTabBarAppearance() {
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor(resource: .tabBarSeparator).cgColor
        tabBar.clipsToBounds = true
    }
}
