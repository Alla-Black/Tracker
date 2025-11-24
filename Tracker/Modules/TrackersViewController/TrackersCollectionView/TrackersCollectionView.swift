import UIKit

// MARK: TrackersCollectionView

final class TrackersCollectionView: NSObject {
    
    // MARK: - Private Properties
    
    private let collectionView: UICollectionView
    private(set) var params: CollectionLayoutParams
    
    private(set) var categories: [TrackerCategory] = []
    
    // MARK: - Initializers
    
    init(using params: CollectionLayoutParams, collectionView: UICollectionView) {
    
        self.params = params
        self.collectionView = collectionView
        
        super.init()
        
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        
        collectionView.register(TrackerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSectionHeaderView.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Public Methods
    
    func update(with categories: [TrackerCategory]) {
        self.categories = categories
        collectionView.reloadData()
    }
    
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
    
    func addCategory(_ category: TrackerCategory) {
        // TODO: в след. спринте реализовать функцию добавления новых категорий (категории)
    }
    
}
