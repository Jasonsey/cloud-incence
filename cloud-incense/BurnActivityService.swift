// BurnActivityService.swift
// Manages Live Activity lifecycle driven by BurnSession state changes.
// On platforms/versions that don't support Live Activities the methods are no-ops.

import Foundation
#if os(iOS)
import ActivityKit
#endif

final class BurnActivityService {
    static let shared = BurnActivityService()
    private init() {}
    
    /// Maximum length for prayer summary display (prevents truncation issues).
    private let maxPrayerSummaryLength: Int = 60

    // MARK: - Public API

    /// Called when burning starts. Requests a new Live Activity.
    /// - Parameters:
    ///   - endDate: When the burn session will end
    ///   - prayerText: User's prayer text (if any); will be used as summary
    func start(endDate: Date, prayerText: String = "") {
        #if os(iOS)
        guard #available(iOS 16.2, *) else { return }
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        let startDate = Date()
        // Truncate prayer text to fit display constraints
        let truncatedPrayer = String(prayerText.prefix(maxPrayerSummaryLength))
        
        let attrs = BurnActivityAttributes()
        let state = BurnActivityAttributes.ContentState(
            phase: "burning",
            endDate: endDate,
            startDate: startDate,
            prayerSummary: truncatedPrayer
        )
        let content = ActivityContent(
            state: state,
            staleDate: endDate.addingTimeInterval(120)   // mark stale 2 min after expected end
        )
        _ = try? Activity.request(attributes: attrs, content: content, pushType: nil)
        #endif
    }

    /// Called when burning completes or is reset. Ends all active burn activities.
    func end() {
        #if os(iOS)
        guard #available(iOS 16.2, *) else { return }
        Task {
            for activity in Activity<BurnActivityAttributes>.activities {
                let state = BurnActivityAttributes.ContentState(
                    phase: "complete",
                    endDate: Date(),
                    startDate: Date(),
                    prayerSummary: ""
                )
                let content = ActivityContent(state: state, staleDate: nil)
                // Show completion state briefly, then dismiss
                await activity.end(content, dismissalPolicy: .after(Date().addingTimeInterval(10)))
            }
        }
        #endif
    }
    
    /// Updates an ongoing Live Activity with new state.
    /// - Parameters:
    ///   - phase: Current burn phase
    ///   - endDate: When the burn will end
    ///   - startDate: When the burn started
    ///   - prayerSummary: Prayer text to display
    func updateState(phase: String, endDate: Date, startDate: Date, prayerSummary: String = "") {
        #if os(iOS)
        guard #available(iOS 16.2, *) else { return }
        Task {
            for activity in Activity<BurnActivityAttributes>.activities {
                let state = BurnActivityAttributes.ContentState(
                    phase: phase,
                    endDate: endDate,
                    startDate: startDate,
                    prayerSummary: prayerSummary
                )
                await activity.update(ActivityContent(state: state, staleDate: endDate.addingTimeInterval(120)))
            }
        }
        #endif
    }
}
