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
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView, didRequestEdit tracker: Tracker)
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView, didRequestDeleteAt indexPath: IndexPath)
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

// MARK: - UICollectionViewDelegate (Context Menu)

extension TrackersCollectionView: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {

        guard let tracker = delegate?.trackersCollectionView(self, trackerAt: indexPath) else {
            return nil
        }

        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { [weak self] _ in
            guard let self else { return UIMenu() }

            let editAction = UIAction(title: "Редактировать") { [weak self] _ in
                guard let self else { return }
                self.delegate?.trackersCollectionView(self, didRequestEdit: tracker)
            }

            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                guard let self else { return }
                self.delegate?.trackersCollectionView(self, didRequestDeleteAt: indexPath)
            }

            return UIMenu(children: [editAction, deleteAction])
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {

        guard
            let indexPath = (configuration.identifier as? NSIndexPath) as IndexPath?,
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell
        else { return nil }

        let previewView = cell.contextMenuPreviewView

        let params = UIPreviewParameters()
        params.backgroundColor = .clear
        params.visiblePath = UIBezierPath(
            roundedRect: previewView.bounds,
            cornerRadius: previewView.layer.cornerRadius
        )

        return UITargetedPreview(view: previewView, parameters: params)
    }

    /// Возвращает preview для анимации закрытия контекстного меню,
    /// чтобы оно схлопывалось обратно в верхнюю карточку трекера
    /// без захвата футера.
    func collectionView(
        _ collectionView: UICollectionView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        return self.collectionView(collectionView, previewForHighlightingContextMenuWithConfiguration: configuration)
    }
}
