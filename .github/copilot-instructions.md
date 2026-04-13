# 云香 (Cloud Incense) — Agent Guidelines

## Project Overview

SwiftUI incense meditation app for iOS/macOS/visionOS. Users write a prayer, ignite incense sticks, and watch them burn with realistic smoke and ash physics. Features Live Activity progress on Dynamic Island.

- **Docs**: [UI Style Guide](../docs/ui-style-guide.md) · [Localization](../docs/localization.md)
- **Specs**: `openspec/specs/` for feature specifications; `openspec/changes/archive/` for completed change history

## Architecture

```
cloud_incenseApp (@main)
  └─ @State BurnSession (@Observable) — central state machine
  └─ @State TiltManager (@Observable) — CoreMotion filtered gravity
       └─ ContentView
            ├─ IncenseCanvasView
            │    ├─ IncenseSmokeView → SmokeScene (SpriteKit)
            │    ├─ IncenseStickView × 3 (AshTrailShape physics)
            │    └─ IncenseHolderView
            ├─ PrayerInputView
            └─ CompletionView (full-screen overlay)

Services (singletons):
  BurnActivityService — ActivityKit Live Activity lifecycle
  NotificationService — UserNotifications completion alert
```

**State machine**: `idle → composing → lighting → burning → complete`
**Observation**: `@Observable` + `.environment()` injection (iOS 17+). No Combine, no ObservableObject.

## Build & Targets

| Target | Bundle ID |
|---|---|
| `cloud-incense` (main app) | `top.dropx.cloud-incense` |
| `cloud-incense-liveExtension` (widget) | `top.dropx.cloud-incense.cloud-incense-live` |

**Deployment**: iOS 26.4 / macOS 26.3 / visionOS 26.4  
**Build**: Open `cloud-incense.xcodeproj` in Xcode. No SPM dependencies in main target (SpriteKit/ActivityKit are system frameworks).

## Critical Gotchas

**`BurnActivityAttributes` must stay in sync** between both targets manually — any field mismatch causes a silent runtime crash with no compile error.

**CoreMotion coordinate mapping is non-trivial** — `TiltManager` remaps gravity vector per device orientation (portrait/landscape left/right/upside-down). Do not simplify this logic; see the mapping table in `TiltManager.swift`.

**`BurnSession.burnDuration = 60`** (seconds) — deliberately short for testing. Production intent is 21 minutes. Don't change without updating tests.

**Platform guards required** for: `CoreMotion`, `ActivityKit`, `UserNotifications` — wrap in `#if os(iOS)`. macOS and visionOS silently skip these blocks.

**SpriteKit ↔ SwiftUI bridge**: `SmokeScene` state is driven entirely via `onChange` callbacks from SwiftUI (not direct observation). Do not add @Observable to SpriteKit classes.

## Conventions

**UI style**: Pure black background + glowing white neon strokes. See [docs/ui-style-guide.md](../docs/ui-style-guide.md) before touching visual code.

**Ash physics** (`AshTrailShape`): Chain-integration model — each stick has an `AshSeed` struct with curl, loop, and tail parameters. Treat as a physics engine; test visually after any change.

**AppIcon-first design**: All UI color/glow decisions reference the dark icon aesthetic (pure black, white luminous lines, no warm colors).

**Localization**: App name is in `{lang}.lproj/InfoPlist.strings`, not in build settings. See [docs/localization.md](../docs/localization.md).

**openspec workflow**: Feature proposals, designs, and tasks live in `openspec/changes/`. Use the `openspec-propose`, `openspec-apply-change`, `openspec-explore`, and `openspec-archive-change` skills for structured feature work.

## Key File Map

| File | Role |
|---|---|
| `cloud-incense/BurnSession.swift` | State machine, progress tracking, ignition logic |
| `cloud-incense/TiltManager.swift` | CoreMotion → screen-space tilt, low-pass filter (α=0.12) |
| `cloud-incense/IncenseCanvasView.swift` | All visual components incl. `AshTrailShape` math |
| `cloud-incense/SmokeScene.swift` | SpriteKit particle emitters + tilt-reactive acceleration |
| `cloud-incense/BurnActivityService.swift` | Live Activity start/update/end (iOS 16.2+ only) |
| `cloud-incense/BurnActivityAttributes.swift` | Shared ActivityKit model — keep in sync with extension |
| `cloud-incense-live/cloud_incense_live.swift` | Lock screen + Dynamic Island Live Activity views |
