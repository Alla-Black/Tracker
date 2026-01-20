import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {
    
    private func assertTrackersSnapshot(
        userInterfaceStyle: UIUserInterfaceStyle,
        testName: String
    ) {
        let vc = TrackersViewController()
        
        assertSnapshot(
            of: vc,
            as: .image(
                on: .iPhone13,
                traits: .init(userInterfaceStyle: userInterfaceStyle)
            ),
            testName: testName
        )
    }
    
    func testMainScreenLightTheme() {
        assertTrackersSnapshot(userInterfaceStyle: .light, testName: #function)
    }
    
    func testMainScreenDarkTheme() {
            assertTrackersSnapshot(userInterfaceStyle: .dark, testName: #function)
    }
    
}
