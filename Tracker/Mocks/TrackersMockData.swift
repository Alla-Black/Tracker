import UIKit

enum TrackersMockData {
    static func makeCategories() -> [TrackerCategory] {
        let tracker1 = Tracker(
            id: UUID(),
            name: "Ежедневно поливать цветы",
            color: UIColor(resource: .blueYP),
            emoji: "🌺",
            schedule: []
        )
        
        let tracker2 = Tracker(
            id: UUID(),
            name: "Гулять 30 минут в день",
            color: UIColor(resource: .redYP),
            emoji: "🚶‍♀️",
            schedule: []
        )
        
        let tracker3 = Tracker(
            id: UUID(),
            name: "Гладить кошку каждый день",
            color: UIColor(resource: .grayYP),
            emoji: "😻",
            schedule: []
        )
        
        let tracker4 = Tracker(
            id: UUID(),
            name: "Свидание с парнем каждый выходной день",
            color: UIColor(resource: .redYP),
            emoji: "❤️",
            schedule: []
        )
        
        let importantCategory = TrackerCategory(title: "Важное", trackers: [tracker1, tracker2, tracker3, tracker4])
        
        return [importantCategory]
    }
}
