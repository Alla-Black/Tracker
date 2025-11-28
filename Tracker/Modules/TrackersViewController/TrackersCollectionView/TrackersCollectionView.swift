import UIKit

// MARK: - TrackersCollectionViewDelegate Protocol

protocol TrackersCollectionViewDelegate: AnyObject {
    func trackersCollectionView(_ collectionView: TrackersCollectionView, didTapPlusFor tracker: Tracker, at indexPath: IndexPath)
    
    func trackersCollectionView(
        _ collectionView: TrackersCollectionView,
        completedCountFor tracker: Tracker
    ) -> Int
    
    func trackersCollectionView(
        _ collectionView: TrackersCollectionView,
        isCompleted tracker: Tracker
    ) -> Bool
}

// MARK: TrackersCollectionView

final class TrackersCollectionView: NSObject {
    
    // MARK: - Public Properties
    
    weak var delegate: TrackersCollectionViewDelegate?
    
    // MARK: - Private Properties
    
    private let collectionView: UICollectionView
    private(set) var params: CollectionLayoutParams
    
    private(set) var categories: [TrackerCategory] = []
    
    // MARK: - Initializers
    
    init(using params: CollectionLayoutParams, collectionView: UICollectionView) {
    
        self.params = params
        self.collectionView = collectionView
        
        super.init()
        
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        
        collectionView.register(
            TrackerSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSectionHeaderView.identifier
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Public Methods
    
    func update(with categories: [TrackerCategory]) {
        self.categories = categories
        collectionView.reloadData()
    }
    
    func reloadItems(at indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }
    
    // Сейчас не используется: коллекция обновляется через applyFilter в контроллере.
    // Оставлено временно на всякий случай
    
    /*
    func addTracker(_ tracker: Tracker, to categoryIndex: Int) {
        
        guard categories.indices.contains(categoryIndex) else { return }
        
        let oldCategory = categories[categoryIndex]
        let newTrackers = oldCategory.trackers + [tracker]
        
        let updatedCategory = TrackerCategory(
            title: oldCategory.title,
            trackers: newTrackers
            )
        
        categories[categoryIndex] = updatedCategory
        
        let itemIndex = newTrackers.count - 1
        let indexPath = IndexPath(item: itemIndex, section: categoryIndex)
        
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [indexPath])
        }, completion: nil)
    }
     */
    
    func addCategory(_ category: TrackerCategory) {
        // TODO: в след. спринте реализовать функцию добавления новых категорий (категории)
    }
    
}

// MARK: - Extension TrackerCellDelegate

extension TrackersCollectionView: TrackerCellDelegate {
    
    func trackerCellDidTapPlus(_ cell: TrackerCollectionViewCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let tracker = categories[indexPath.section].trackers[indexPath.item]
        
        delegate?.trackersCollectionView(self, didTapPlusFor: tracker, at: indexPath)
    }
}
