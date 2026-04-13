<div align="center">
  <img src="cloud-incense/Assets.xcassets/AppIcon.appiconset/AppIcon1024x1024.png" width="120" alt="云香 App Icon" />

  # 云香 · Cloud Incense

  **一款专注于内心宁静的线香冥想 App**

  iOS · macOS · visionOS &nbsp;|&nbsp; SwiftUI · SpriteKit · ActivityKit

  [![Platform](https://img.shields.io/badge/platform-iOS%2026%2B%20%7C%20macOS%2026%2B%20%7C%20visionOS%2026%2B-black?style=flat-square)](https://developer.apple.com/swift/)
  [![Swift](https://img.shields.io/badge/Swift-6-f05138?style=flat-square&logo=swift)](https://swift.org)
  [![License](https://img.shields.io/badge/license-Apache%202.0-white?style=flat-square)](LICENSE)
</div>

---

## 截图

> 将截图文件放置于 `docs/screenshots/` 目录，命名规范见下表。

<div align="center">

| 祈祷输入 | 点燃过程 | 燃烧中 | 完成 |
|:---:|:---:|:---:|:---:|
| <img src="docs/screenshots/01-prayer-input.png" width="180" alt="祈祷输入界面" /> | <img src="docs/screenshots/02-lighting.png" width="180" alt="点燃过程" /> | <img src="docs/screenshots/03-burning.png" width="180" alt="燃烧中" /> | <img src="docs/screenshots/04-complete.png" width="180" alt="完成界面" /> |

| Dynamic Island（展开） | 锁屏实时活动 |
|:---:|:---:|
| <img src="docs/screenshots/05-dynamic-island.png" width="280" alt="Dynamic Island 展开视图" /> | <img src="docs/screenshots/06-lock-screen.png" width="280" alt="锁屏实时活动" /> |

</div>

---

## 功能亮点

- **沉浸式线香场景** — 三根香棒依次点燃，搭配基于 SpriteKit 的粒子烟雾，随手机倾斜实时飘动
- **真实灰烬物理** — 链式积分模型（`AshTrailShape`）驱动灰烬卷曲、成环、拖尾，逐帧生长
- **动态祈祷输入** — 点燃前在极简黑底界面书写祈祷词，字符随焦点柔和浮现
- **Live Activity 进度追踪** — Dynamic Island 展开视图 + 锁屏卡片，实时显示燃烧进度与祈祷摘要
- **完成庆典** — 燃尽后以全屏叠加动效与本地推送提醒收尾
- **多平台支持** — 同一套 SwiftUI 代码覆盖 iPhone / iPad / Mac / Apple Vision Pro

---

## 界面风格

纯黑背景 + 霓虹发光白色描边，参考 App 图标的禅意美学：

```
纯黑底  Color.black
白色描边 + 多层 .shadow 模拟发光光晕（bloom）
极低透明度填充  white.opacity(0.04 ~ 0.08)
```

详见 [docs/ui-style-guide.md](docs/ui-style-guide.md)。

---

## 架构概览

```
cloud_incenseApp (@main)
  └─ BurnSession (@Observable)   状态机：idle → composing → lighting → burning → complete
  └─ TiltManager (@Observable)   CoreMotion 重力向量 → 屏幕空间倾斜（低通滤波 α=0.12）
       └─ ContentView
            ├─ IncenseCanvasView
            │    ├─ IncenseSmokeView → SmokeScene (SpriteKit 粒子)
            │    ├─ IncenseStickView × 3  (AshTrailShape 灰烬物理)
            │    └─ IncenseHolderView
            ├─ PrayerInputView
            └─ CompletionView

服务层（单例）：
  BurnActivityService   ActivityKit Live Activity 生命周期管理
  NotificationService   UserNotifications 燃烧完成提醒
```

---

## 本地化

| 区域 | 应用名称 |
|---|---|
| English | Incense |
| 简体中文 | 云香 |
| 繁体中文 | 雲香 |
| 日本語 | 雲香 |
| 한국어 | 인센스 |

---

## 环境要求

| 项目 | 要求 |
|---|---|
| Xcode | 26 Beta 或更高 |
| iOS 部署目标 | 26.4+ |
| macOS 部署目标 | 26.3+ |
| visionOS 部署目标 | 26.4+ |
| Swift | 6 |

---

## 构建运行

```bash
# 克隆仓库
git clone <repo-url>
cd cloud-incense

# 直接用 Xcode 打开
open cloud-incense.xcodeproj
```

在 Xcode 中选择 `cloud-incense` Scheme，连接真机或模拟器后运行即可。  
Live Activity 功能需要 **iPhone 实机**（Dynamic Island 机型体验最佳）。

---

## 目录结构

```
cloud-incense/          主 App 源码（SwiftUI + SpriteKit）
cloud-incense-live/     Live Activity Widget Extension
docs/                   UI 风格指南、本地化规范、截图资源
openspec/               功能规格说明与变更历史
```

---

<div align="center">
  <sub>以静制动，以香传意。</sub>
</div>
