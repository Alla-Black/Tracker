import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Public Properties
    
    var onFinish: (() -> Void)?
    
    // MARK: - Private Properties
    
    private lazy var pages: [UIViewController] = {
        let firstScreen = PageViewController(
            image: UIImage(resource: .firstBackground),
            text: "Отслеживайте только то, что хотите"
        )
        
        let secondScreen = PageViewController(
            image: UIImage(resource: .secondBackground),
            text: "Даже если это не литры воды и йога"
        )
        
        return [firstScreen, secondScreen]
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.whiteStatic, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 16
        button.backgroundColor = .blackStatic
        
        button.addTarget(
            self,
            action: #selector(didTapActionButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .blackStatic
        pageControl.pageIndicatorTintColor = .blackStatic.withAlphaComponent(0.3)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    // MARK: - Initializers
    
    override init(
        transitionStyle: UIPageViewController.TransitionStyle = .pageCurl,
        navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
        options: [UIPageViewController.OptionsKey: Any]? = nil
    ) {
        super.init(
            transitionStyle: transitionStyle,
            navigationOrientation: navigationOrientation,
            options: options
        )
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers(
                [first],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
        
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.addSubviews([actionButton, pageControl])
            
        [actionButton, pageControl].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 60),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -24)
        ])
    }
    
    @objc
    private func didTapActionButton() {
        UserDefaults.standard.set(true, forKey: "hasViewedOnboarding")
        onFinish?()
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

