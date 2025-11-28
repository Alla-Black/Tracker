import UIKit

extension TrackersCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        
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
        
        let title = categories[indexPath.section].title
        view.configure(with: title)
        
        return view
    }
}
