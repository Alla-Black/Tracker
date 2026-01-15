import UIKit

extension TrackersViewController: TrackersCollectionViewDelegate {
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView, didTapPlusFor tracker: Tracker, at indexPath: IndexPath) {
        
        let selectedDate = datePickerView.selectedDate
        
        let today = normalizedDate(Date())
        let normalizedSelected = normalizedDate(selectedDate)
        
        guard normalizedSelected <= today else {
            return
        }
        
        AnalyticsService.shared.reportUIEvent(.click, screen: AnalyticsScreen.main, item: AnalyticsItem.track)
        
        do {
            try dataProvider.toggleRecord(for: tracker, on: selectedDate)
            reloadFromStore()
        } catch {
            assertionFailure("Не удалось изменить запись трекера: \(error)")
        }
    }
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView,
        completedCountFor tracker: Tracker) -> Int {
        
        return completedCount(for: tracker)
    }
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView,
        isCompleted tracker: Tracker) -> Bool {
        let date = datePickerView.selectedDate
        
        return dataProvider.isTrackerCompleted(tracker, on: date)
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
