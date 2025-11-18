import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .trackersButton),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .statisticButton),
            selectedImage: nil
        )
        
        viewControllers = [trackersViewController, statisticViewController]
        
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor(resource: .grayYP).cgColor
        tabBar.clipsToBounds = true
    }
}
