import UIKit

extension TrackersCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return delegate?.numberOfSections(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return delegate?.trackersCollectionView(self, numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let tracker = delegate?.trackersCollectionView(self, trackerAt: indexPath) else {
            return cell
        }
        
        let days = delegate?.trackersCollectionView(self, completedCountFor: tracker) ?? 0
        let isCompleted = delegate?.trackersCollectionView(self, isCompleted: tracker) ?? false
        
        cell.configure(with: tracker, days: days, isCompleted: isCompleted)
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = TrackerSectionHeaderView.identifier
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as?  TrackerSectionHeaderView else { return UICollectionReusableView() }
        
        let title = delegate?.trackersCollectionView(self, titleForSection: indexPath.section) ?? ""
        view.configure(with: title)
        
        return view
    }
}
