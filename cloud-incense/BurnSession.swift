import Foundation
import Observation

enum BurnState: Equatable {
    case idle
    case composing
    case lighting
    case burning
    case complete
}

@MainActor
@Observable
final class BurnSession {
    static let burnDuration: TimeInterval = 1260  // 21 minutes
    // static let burnDuration: TimeInterval = 60  // 21 minutes

    var state: BurnState = .idle
    var prayerText: String = ""
    var startDate: Date? = nil
    var progress: Double = 0.0
    // Indices: 0 = left, 1 = center, 2 = right; ignition order: center → left → right
    var litSticks: [Bool] = [false, false, false]

    func updateProgress() {
        guard let start = startDate, state == .burning else { return }
        let elapsed = Date().timeIntervalSince(start)
        progress = min(elapsed / Self.burnDuration, 1.0)
        if progress >= 1.0 {
            state = .complete
            BurnActivityService.shared.end()
        }
    }

    func ignite() async {
        guard state == .idle || state == .composing else { return }
        state = .lighting
        // Center first
        litSticks[1] = true
        try? await Task.sleep(for: .milliseconds(300))
        // Left
        litSticks[0] = true
        try? await Task.sleep(for: .milliseconds(300))
        // Right
        litSticks[2] = true
        startBurning()
    }

    func startBurning() {
        startDate = Date()
        state = .burning
        NotificationService.shared.scheduleBurnComplete()
        BurnActivityService.shared.start(
            endDate: Date().addingTimeInterval(Self.burnDuration),
            prayerText: prayerText
        )
    }

    func reset() {
        BurnActivityService.shared.end()
        state = .idle
        prayerText = ""
        startDate = nil
        progress = 0.0
        litSticks = [false, false, false]
        NotificationService.shared.cancelAll()
    }
}
