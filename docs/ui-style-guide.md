# UI 风格指南

## 设计语言

整体风格参考 App 图标设计——**纯黑底 + 霓虹发光白线**，营造极简禅意美感。

### 核心原则

- **背景**：纯黑 `Color.black`，无任何渐变或杂色
- **元素**：白色描边 + 多层 `.shadow` 模拟发光光晕（bloom）
- **填充**：极低透明度白色（`white.opacity(0.04~0.08)`），保持"玻璃感"
- **文字**：白色，辅助文字使用 `white.opacity(0.35~0.55)`
- **强调色**：白色（取代原橙色），包括光标、选中高亮

---

## 各组件规范

### 背景（ContentView）

```swift
Color.black.ignoresSafeArea()
```

### 香炉（IncenseHolderView）

| 部件 | 样式 |
|---|---|
| 托盘 / 底座 | `RoundedRectangle` + `stroke(white, 1.5pt)` + 双层白色 shadow |
| 颈部 | `Capsule` + `fill(white.opacity(0.4))` + 发光 shadow |
| 插孔 | `Circle` + 黑色填充 + 细白描边 |

光晕层叠写法：
```swift
.shadow(color: .white.opacity(0.75), radius: 5)
.shadow(color: .white.opacity(0.25), radius: 12)
```

### 香棒（IncenseStickView）

```swift
RoundedRectangle(cornerRadius: 2.5)
    .fill(Color.white.opacity(0.82))
    .shadow(color: .white.opacity(0.6), radius: 3)
    .shadow(color: .white.opacity(0.25), radius: 7)
```

### 燃烧火焰（IncenseStickView）

冷白光风格，取代暖橙色：

```swift
Circle().fill(Color.white.opacity(0.12)).blur(radius: 7)  // 外晕
Circle()  // 核心光点
    .fill(RadialGradient(colors: [.white, Color(white: 0.88, opacity: 0.85)], ...))
    .shadow(color: .white.opacity(0.9), radius: 6)
    .shadow(color: .white.opacity(0.5), radius: 10)
```

### 输入框（PrayerInputView）

描边 + 极淡填充，取代纯色背景：

```swift
RoundedRectangle(cornerRadius: 12)
    .stroke(Color.white.opacity(0.18~0.22), lineWidth: 1)
    .background(Color.white.opacity(0.04~0.05).cornerRadius(12))
```

光标色：`.tint(.white)`

### 完成界面遮罩（CompletionView）

```swift
Color.black.opacity(0.7).ignoresSafeArea()
```

### 再次祈祷按钮（CompletionView）

描边 Capsule + 白光 shadow，取代填充背景：

```swift
.overlay(Capsule().stroke(Color.white.opacity(0.35), lineWidth: 1))
.shadow(color: .white.opacity(0.25), radius: 8)
```

---

## 灰阶参考

| 用途 | 值 |
|---|---|
| 描边主要 | `white.opacity(0.65)` |
| 描边次要 | `white.opacity(0.18~0.22)` |
| 棒身填充 | `white.opacity(0.82)` |
| 辅助文字 | `white.opacity(0.35~0.55)` |
| 快速光晕 | `shadow radius: 5~6` |
| 扩散光晕 | `shadow radius: 12~14` |
