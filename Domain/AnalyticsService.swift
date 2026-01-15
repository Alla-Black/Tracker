import Foundation
import AppMetricaCore

// MARK: - Analytics constants

enum AnalyticsEvent: String {
    case open
    case close
    case click
}

enum AnalyticsScreen {
    static let main = "Main"
}

enum AnalyticsItem {
    static let addTrack = "add_track"
    static let track = "track"
    static let filter = "filter"
    static let edit = "edit"
    static let delete = "delete"
}

// MARK: - Service

final class AnalyticsService {
    static let shared = AnalyticsService()
    private init() {}
    
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "f9f44997-b522-407d-9e64-803149da02b2") else { return }
        
        AppMetrica.activate(with: configuration)
    }
    
    func reportUIEvent(
        _ event: AnalyticsEvent,
        screen: String,
        item: String? = nil
    ) {
        var params: [AnyHashable: Any] = [
            "event": event.rawValue,
            "screen": screen
        ]
        
        if let item {
            params["item"] = item
        }
        
#if DEBUG
        print("Analytics ui_event:", params)
#endif
        
        AppMetrica.reportEvent(
            name: "ui_event",
            parameters: params,
            onFailure: { error in
                print("REPORT ERROR: %@", error.localizedDescription)
            }
        )
    }
}
