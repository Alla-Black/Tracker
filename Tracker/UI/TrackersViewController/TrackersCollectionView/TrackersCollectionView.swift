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
    
    func numberOfSections(in collectionView: TrackersCollectionView) -> Int
    
    func trackersCollectionView(
        _ collectionView: TrackersCollectionView,
        numberOfItemsInSection section: Int
    ) -> Int
    
    func trackersCollectionView(
        _ collectionView: TrackersCollectionView,
        trackerAt indexPath: IndexPath
    ) -> Tracker
    
    func trackersCollectionView(
        _ collectionView: TrackersCollectionView,
        titleForSection section: Int
    ) -> String
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
}

// MARK: - Extension TrackerCellDelegate

extension TrackersCollectionView: TrackerCellDelegate {
    
    func trackerCellDidTapPlus(_ cell: TrackerCollectionViewCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell),
        let tracker = delegate?.trackersCollectionView(self, trackerAt: indexPath)
        else { return }
        
        delegate?.trackersCollectionView(self, didTapPlusFor: tracker, at: indexPath)
    }
}
