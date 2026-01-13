import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: AppStrings.MainTab.tabTrackersTitle,
            image: UIImage(resource: .trackersButton),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: AppStrings.MainTab.tabStatisticsTitle,
            image: UIImage(resource: .statisticButton),
            selectedImage: nil
        )
        
        viewControllers = [trackersViewController, statisticViewController]
        
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor(resource: .tabBarSeparator).cgColor
        tabBar.clipsToBounds = true
    }
}
