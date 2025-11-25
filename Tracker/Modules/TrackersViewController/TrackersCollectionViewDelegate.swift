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
}
