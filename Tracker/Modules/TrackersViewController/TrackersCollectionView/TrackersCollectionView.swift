import UIKit

// MARK: - TrackersLayoutParams Struct

struct TrackersLayoutParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpaсing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpaсing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpaсing = cellSpaсing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpaсing
    }
}

// MARK: TrackersCollectionView

final class TrackersCollectionView: NSObject {
    
    // MARK: - Private Properties
    
    private let collectionView: UICollectionView
    private(set) var params: TrackersLayoutParams
    
    private(set) var categories: [TrackerCategory] = []
    
    // MARK: - Initializers
    
    init(using params: TrackersLayoutParams, collectionView: UICollectionView) {
    
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
        // TODO: реализовать функцию добавления новых ячеек (трекеров)
    }
    
    func addCategory(_ category: TrackerCategory) {
        // TODO: реализовать функцию добавления новых категорий (категории)
    }
    
}
