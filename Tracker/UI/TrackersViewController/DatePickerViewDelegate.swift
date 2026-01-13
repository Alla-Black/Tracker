import Foundation

extension TrackersViewController: DatePickerViewDelegate {
    func datePickerView(_ view: DatePickerView, didChangeDate date: Date) {
        applyFilter(for: date)
    }
}
