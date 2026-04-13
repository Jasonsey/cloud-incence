// BurnActivityAttributes.swift
// Shared ActivityKit model visible to both the main app and the Widget Extension.
//
// REQUIRED XCODE SETUP (one-time, manual):
// 1. File > New > Target > Widget Extension, name it e.g. "BurnWidget"
// 2. In the extension wizard, check "Include Live Activity"
// 3. Add this file to the "BurnWidget" target membership as well
// 4. In the main app's Info.plist add: NSSupportsLiveActivities = YES
// 5. Implement the ActivityConfiguration views in the extension target
//
// Without step 1-3 the ActivityKit data layer still compiles and runs;
// Live Activities just won't render in Dynamic Island / Lock Screen.

#if os(iOS)
import Foundation
import ActivityKit

struct BurnActivityAttributes: ActivityAttributes {
    // Static metadata (set at creation time)

    /// ContentState is updated throughout the burn session.
    struct ContentState: Codable, Hashable {
        /// Human-readable phase shown to the user.
        var phase: String     // "burning" | "complete"
        /// When the burn session ends; used by the system for countdown.
        var endDate: Date
        /// Start date of the burn session; used to calculate progress percentage.
        var startDate: Date
        /// User's prayer text (if any); displayed as a summary in the UI.
        /// Truncated to fit in expanded/lock screen views.
        var prayerSummary: String
    }
}
#endif

