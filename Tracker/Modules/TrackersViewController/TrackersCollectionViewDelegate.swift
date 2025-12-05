import UIKit

extension TrackersViewController: TrackersCollectionViewDelegate {
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView, didTapPlusFor tracker: Tracker, at indexPath: IndexPath) {
        
        let selectedDate = datePickerView.selectedDate
        
        let today = normalizedDate(Date())
        let normalizedSelected = normalizedDate(selectedDate)
        
        guard normalizedSelected <= today else {
            return
        }
        
        if isTrackerCompleted(tracker, on: selectedDate) {
            
            completedTrackers.removeAll { record in
                let sameTracker = record.trackerId == tracker.id
                let sameDate = Calendar.current.isDate(normalizedDate(record.date), inSameDayAs: normalizedSelected)
                
                return sameTracker && sameDate
            }
        } else {
            let record = TrackerRecord(trackerId: tracker.id, date: selectedDate)
            completedTrackers.append(record)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView,
        completedCountFor tracker: Tracker) -> Int {
        
        return completedCount(for: tracker)
    }
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView,
        isCompleted tracker: Tracker) -> Bool {
        let date = datePickerView.selectedDate
        
        return isTrackerCompleted(tracker, on: date)
    }
    
    func numberOfSections(in collectionView: TrackersCollectionView) -> Int {
        return visibleCategories.count
    }
    
    func trackersCollectionView(
        _ collectionView: TrackersCollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard visibleCategories.indices.contains(section) else { return 0 }
        return visibleCategories[section].trackers.count
    }
    
    func trackersCollectionView(
        _ collectionView: TrackersCollectionView,
        trackerAt indexPath: IndexPath
    ) -> Tracker {
        return visibleCategories[indexPath.section].trackers[indexPath.item]
    }
    
    func trackersCollectionView(
        _ collectionView: TrackersCollectionView,
        titleForSection section: Int
    ) -> String {
        guard visibleCategories.indices.contains(section) else { return "" }
        return visibleCategories[section].title
    }
}
