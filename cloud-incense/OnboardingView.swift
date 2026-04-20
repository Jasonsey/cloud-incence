//
//  OnboardingView.swift
//  cloud-incense
//

import SwiftUI

// MARK: - Model

private enum TutorialTarget {
    case incenseStick   // center stick tap target
    case prayerInput    // text field at bottom
}

private struct TutorialStep {
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    let target: TutorialTarget?
}

// MARK: - Callout Bubble Shape

private struct CalloutBubble: Shape {
    var tailPointsUp: Bool
    var tailNormX: CGFloat = 0.5
    var cornerRadius: CGFloat = 16
    var tailWidth: CGFloat = 24
    var tailHeight: CGFloat = 16

    func path(in rect: CGRect) -> Path {
        let cr = cornerRadius
        let tw = tailWidth / 2
        let th = tailHeight

        // Body rect: excludes the tail protrusion area
        let bMinY: CGFloat = tailPointsUp ? th : 0
        let bMaxY: CGFloat = tailPointsUp ? rect.height : rect.height - th
        let tipX = max(cr + tw + 4, min(rect.width - cr - tw - 4, rect.width * tailNormX))

        var p = Path()

        // Start at top-left after corner
        p.move(to: CGPoint(x: cr, y: bMinY))

        if tailPointsUp {
            // Tail protrudes upward from top edge
            p.addLine(to: CGPoint(x: tipX - tw, y: bMinY))
            p.addLine(to: CGPoint(x: tipX, y: 0))
            p.addLine(to: CGPoint(x: tipX + tw, y: bMinY))
        }

        // Top edge → top-right corner
        p.addLine(to: CGPoint(x: rect.width - cr, y: bMinY))
        p.addArc(center: CGPoint(x: rect.width - cr, y: bMinY + cr), radius: cr,
                 startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)

        // Right edge → bottom-right corner
        p.addLine(to: CGPoint(x: rect.width, y: bMaxY - cr))
        p.addArc(center: CGPoint(x: rect.width - cr, y: bMaxY - cr), radius: cr,
                 startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)

        if !tailPointsUp {
            // Tail protrudes downward from bottom edge
            p.addLine(to: CGPoint(x: tipX + tw, y: bMaxY))
            p.addLine(to: CGPoint(x: tipX, y: rect.height))
            p.addLine(to: CGPoint(x: tipX - tw, y: bMaxY))
        }

        // Bottom edge → bottom-left corner
        p.addLine(to: CGPoint(x: cr, y: bMaxY))
        p.addArc(center: CGPoint(x: cr, y: bMaxY - cr), radius: cr,
                 startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)

        // Left edge → top-left corner
        p.addLine(to: CGPoint(x: 0, y: bMinY + cr))
        p.addArc(center: CGPoint(x: cr, y: bMinY + cr), radius: cr,
                 startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

        p.closeSubpath()
        return p
    }
}

// MARK: - Bubble Card Content

private struct BubbleCard: View {
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    let totalSteps: Int
    let currentStep: Int
    let tailPointsUp: Bool
    let hasTail: Bool
    let onNext: () -> Void

    private let tailH: CGFloat = 16

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .white.opacity(0.9), radius: 6)
                    .shadow(color: .white.opacity(0.5), radius: 18)

                Text(description)
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
            }

            VStack(spacing: 14) {
                HStack(spacing: 7) {
                    ForEach(0..<totalSteps, id: \.self) { i in
                        Circle()
                            .fill(Color.white.opacity(i == currentStep ? 1 : 0.3))
                            .frame(width: i == currentStep ? 8 : 5,
                                   height: i == currentStep ? 8 : 5)
                            .shadow(color: .white.opacity(i == currentStep ? 1 : 0), radius: 5)
                    }
                }

                Button(action: onNext) {
                    Text(currentStep < totalSteps - 1
                         ? LocalizedStringKey("onboarding.button.next")
                         : LocalizedStringKey("onboarding.button.start"))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .overlay(Capsule().stroke(Color.white.opacity(0.85), lineWidth: 1.5))
                        .shadow(color: .white.opacity(0.8), radius: 6)
                        .shadow(color: .white.opacity(0.35), radius: 16)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(24)
        // Reserve space for the tail so the callout shape fills correctly
        .padding(.top, hasTail && tailPointsUp ? tailH : 0)
        .padding(.bottom, hasTail && !tailPointsUp ? tailH : 0)
        .background(bubbleBackground)
        .overlay(bubbleStroke)
        .shadow(color: .white.opacity(0.22), radius: 20)
        .shadow(color: .white.opacity(0.08), radius: 40)
    }

    @ViewBuilder private var bubbleBackground: some View {
        if hasTail {
            CalloutBubble(tailPointsUp: tailPointsUp)
                .fill(Color.white.opacity(0.13))
        } else {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.13))
        }
    }

    @ViewBuilder private var bubbleStroke: some View {
        if hasTail {
            CalloutBubble(tailPointsUp: tailPointsUp)
                .stroke(Color.white.opacity(0.55), lineWidth: 1.5)
        } else {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.55), lineWidth: 1.5)
        }
    }
}

// MARK: - Main Onboarding View

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentStep = 0

    private let steps: [TutorialStep] = [
        TutorialStep(title: "onboarding.step1.title",
                     description: "onboarding.step1.description",
                     target: nil),
        TutorialStep(title: "onboarding.step2.title",
                     description: "onboarding.step2.description",
                     target: .prayerInput),
        TutorialStep(title: "onboarding.step3.title",
                     description: "onboarding.step3.description",
                     target: .incenseStick),
    ]

    var body: some View {
        ZStack {
            Color.black.opacity(0.82).ignoresSafeArea()

            GeometryReader { geo in
                ZStack {
                    ForEach(steps.indices, id: \.self) { i in
                        if i == currentStep {
                            positionedBubble(steps[i], geo: geo)
                                .transition(
                                    .opacity.combined(with: .scale(
                                        scale: 0.96,
                                        anchor: scaleAnchor(steps[i])
                                    ))
                                )
                        }
                    }
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.85), value: currentStep)
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Bubble Placement

    private func positionedBubble(_ step: TutorialStep, geo: GeometryProxy) -> some View {
        let bubbleW: CGFloat = min(geo.size.width - 56, 300)
        // Total estimated frame height: body content (~220pt) + tail (16pt)
        let frameH: CGFloat = 236

        let (centerX, centerY, tailPointsUp): (CGFloat, CGFloat, Bool) = {
            guard let target = step.target else {
                return (geo.size.width / 2, geo.size.height / 2, false)
            }
            let tipY = tailTipY(target, geo: geo)
            switch target {
            case .prayerInput:
                // Tail at bubble bottom, tip points down to input top
                return (geo.size.width / 2, tipY - frameH / 2, false)
            case .incenseStick:
                // Tail at bubble top, tip points up to stick
                return (geo.size.width / 2, tipY + frameH / 2, true)
            }
        }()

        return BubbleCard(
            title: step.title,
            description: step.description,
            totalSteps: steps.count,
            currentStep: currentStep,
            tailPointsUp: tailPointsUp,
            hasTail: step.target != nil,
            onNext: advance
        )
        .frame(width: bubbleW)
        .position(x: centerX, y: centerY)
    }

    private func scaleAnchor(_ step: TutorialStep) -> UnitPoint {
        switch step.target {
        case .prayerInput:  .bottom
        case .incenseStick: .top
        case nil:           .center
        }
    }

    // MARK: - Tail Tip Coordinate
    //
    // ContentView layout (inside safe area):
    //   Spacer() [flex]
    //   IncenseCanvasView  height = 340
    //   Spacer(height: 28)
    //   PrayerInputView    height ≈ 55
    //   Spacer() [flex]

    private func tailTipY(_ target: TutorialTarget, geo: GeometryProxy) -> CGFloat {
        let safeTop    = geo.safeAreaInsets.top
        let safeBottom = geo.safeAreaInsets.bottom
        let totalH     = geo.size.height

        let canvasH: CGFloat = 340
        let holderH: CGFloat = 50
        let stickH:  CGFloat = 200
        let gapH:    CGFloat = 28
        let inputH:  CGFloat = 55

        let usable    = totalH - safeTop - safeBottom
        let fixed     = canvasH + gapH + inputH
        let spacer    = max(0, (usable - fixed) / 2)
        let canvasTop = safeTop + spacer

        switch target {
        case .incenseStick:
            // Point to the center of the center incense stick
            let holderTop  = canvasTop + canvasH - holderH
            let stickTop   = holderTop - stickH
            return stickTop + stickH * 0.5

        case .prayerInput:
            // Point to the top of the prayer input field
            return canvasTop + canvasH + gapH
        }
    }

    private func advance() {
        if currentStep < steps.count - 1 { currentStep += 1 } else { onComplete() }
    }
}
