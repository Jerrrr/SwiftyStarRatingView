//
//  SwiftyStarRatingView.swift
//  SwiftyStarRatingView
//
//  Created by jerry on 16/12/2.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

public typealias SSRVGestureHandler = (_ gesture: UIGestureRecognizer) -> Bool

@IBDesignable
public class SwiftyStarRatingView: UIControl {

    public var shouldBecomeFirstResponder: Bool = false
    public var shouldBeginGestureHandler: SSRVGestureHandler?

    private var ratingRange: ClosedRange<CGFloat> {
        return minimumValue...maximumValue
    }

    private var starCount: Int {
        return max(Int(ceil(maximumValue)), 1)
    }

    private var isRightToLeft: Bool {
        return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
    }

    @IBInspectable public var minimumValue: CGFloat = 0 {
        didSet {
            minimumValue = max(minimumValue, 0)
            if maximumValue < minimumValue {
                maximumValue = minimumValue
            }
            value = clampedValue(value)
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }

    @IBInspectable public var maximumValue: CGFloat = 5 {
        didSet {
            maximumValue = max(maximumValue, minimumValue)
            value = clampedValue(value)
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }

    @IBInspectable public var value: CGFloat = 0 {
        didSet {
            let clamped = clampedValue(value)
            if value != clamped {
                value = clamped
                return
            }

            if value != oldValue && continuous {
                sendActions(for: .valueChanged)
            }

            accessibilityValue = formattedAccessibilityValue
            setNeedsDisplay()
        }
    }

    @IBInspectable public var spacing: CGFloat = 5 {
        didSet {
            spacing = max(spacing, 0)
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }

    @IBInspectable public var continuous: Bool = true

    @IBInspectable public var allowsHalfStars: Bool = true {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var accurateHalfStars: Bool = true {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var emptyStarImage: UIImage? {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var halfStarImage: UIImage? {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var filledStarImage: UIImage? {
        didSet { setNeedsDisplay() }
    }

    private var shouldUseImages: Bool {
        return emptyStarImage != nil && filledStarImage != nil
    }

    override public var isEnabled: Bool {
        didSet {
            updateAppearance(enabled: isEnabled)
        }
    }

    override public var canBecomeFirstResponder: Bool {
        return shouldBecomeFirstResponder
    }

    override public var intrinsicContentSize: CGSize {
        let height: CGFloat = 44.0
        let width = CGFloat(starCount) * height + CGFloat(starCount - 1) * spacing
        return CGSize(width: width, height: height)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    override public func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsDisplay()
    }

    override public func draw(_ rect: CGRect) {
        guard maximumValue > 0, rect.width > 0, rect.height > 0 else {
            return
        }

        backgroundColor?.setFill()
        UIRectFill(rect)

        let availableWidth = max(rect.width - 2 - (spacing * CGFloat(starCount - 1)), 0)
        let cellWidth = availableWidth / CGFloat(starCount)
        let starSide = min(cellWidth, rect.height)

        for visualIndex in 0..<starCount {
            let ratingIndex = isRightToLeft ? starCount - visualIndex - 1 : visualIndex
            let center = CGPoint(
                x: (cellWidth + spacing) * CGFloat(visualIndex) + cellWidth / 2 + 1,
                y: rect.height / 2
            )
            let frame = CGRect(
                x: center.x - starSide / 2,
                y: center.y - starSide / 2,
                width: starSide,
                height: starSide
            )
            let progress = starProgress(at: ratingIndex)
            drawStar(frame: frame, progress: progress, rightToLeft: isRightToLeft)
        }
    }
}

private extension SwiftyStarRatingView {

    func customInit() {
        isExclusiveTouch = true
        isAccessibilityElement = true
        accessibilityTraits.insert(.adjustable)
        accessibilityValue = formattedAccessibilityValue
        updateAppearance(enabled: isEnabled)
    }

    func clampedValue(_ value: CGFloat) -> CGFloat {
        return min(max(value, minimumValue), maximumValue)
    }

    func starProgress(at index: Int) -> CGFloat {
        let lowerBound = CGFloat(index)
        let upperBound = CGFloat(index + 1)

        if value >= upperBound {
            return 1
        }

        if value <= lowerBound {
            return 0
        }

        return value - lowerBound
    }

    func drawStar(frame: CGRect, progress: CGFloat, rightToLeft: Bool) {
        if shouldUseImages {
            drawStarImage(frame: frame, progress: progress, rightToLeft: rightToLeft)
        } else {
            drawStarShape(frame: frame, progress: progress, rightToLeft: rightToLeft)
        }
    }

    func updateAppearance(enabled: Bool) {
        alpha = enabled ? 1.0 : 0.5
    }
}

private extension SwiftyStarRatingView {

    func drawStarImage(frame: CGRect, progress: CGFloat, rightToLeft: Bool) {
        if let emptyStarImage = emptyStarImage {
            draw(image: emptyStarImage, frame: frame)
        }

        guard progress > 0 else {
            return
        }

        if !accurateHalfStars && progress < 1, let halfStarImage = halfStarImage {
            draw(image: halfStarImage, frame: frame)
            return
        }

        guard let filledStarImage = filledStarImage else {
            drawStarShape(frame: frame, progress: progress, rightToLeft: rightToLeft)
            return
        }

        drawCropped(image: filledStarImage, frame: frame, progress: progress, rightToLeft: rightToLeft)
    }

    func drawCropped(image: UIImage, frame: CGRect, progress: CGFloat, rightToLeft: Bool) {
        guard let cgImage = image.cgImage else {
            draw(image: image, frame: frame)
            return
        }

        let clampedProgress = min(max(progress, 0), 1)
        let pixelWidth = CGFloat(cgImage.width)
        let pixelHeight = CGFloat(cgImage.height)
        let cropWidth = max(pixelWidth * clampedProgress, 1)
        let cropX = rightToLeft ? pixelWidth - cropWidth : 0
        let cropRect = CGRect(x: cropX, y: 0, width: cropWidth, height: pixelHeight).integral

        guard let imageRef = cgImage.cropping(to: cropRect) else {
            draw(image: image, frame: frame)
            return
        }

        let croppedImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        var drawFrame = frame
        drawFrame.size.width *= clampedProgress
        if rightToLeft {
            drawFrame.origin.x = frame.maxX - drawFrame.width
        }

        draw(image: croppedImage.withRenderingMode(image.renderingMode), frame: drawFrame)
    }

    func draw(image: UIImage, frame: CGRect) {
        image.draw(in: frame)
    }
}

private extension SwiftyStarRatingView {

    func drawStarShape(frame: CGRect, progress: CGFloat, rightToLeft: Bool) {
        let starShapePath = UIBezierPath()
        starShapePath.move(to: CGPoint(x: frame.minX + 0.62723 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.02500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.37292 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.02500 * frame.width, y: frame.minY + 0.39112 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.30504 * frame.width, y: frame.minY + 0.62908 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.20642 * frame.width, y: frame.minY + 0.97500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.78265 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.79358 * frame.width, y: frame.minY + 0.97500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.69501 * frame.width, y: frame.minY + 0.62908 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.97500 * frame.width, y: frame.minY + 0.39112 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.62723 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.close()
        starShapePath.miterLimit = 4

        let clampedProgress = min(max(progress, 0), 1)
        let fillWidth = frame.width * clampedProgress
        let fillRect = rightToLeft
            ? CGRect(x: frame.maxX - fillWidth, y: frame.minY, width: fillWidth, height: frame.height)
            : CGRect(x: frame.minX, y: frame.minY, width: fillWidth, height: frame.height)

        if clampedProgress > 0, let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            UIBezierPath(rect: fillRect).addClip()
            tintColor.setFill()
            starShapePath.fill()
            context.restoreGState()
        }

        tintColor.setStroke()
        starShapePath.lineWidth = 1
        starShapePath.stroke()
    }
}

extension SwiftyStarRatingView {

    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard isEnabled else {
            return false
        }

        super.beginTracking(touch, with: event)
        if shouldBecomeFirstResponder && !isFirstResponder {
            becomeFirstResponder()
        }
        handle(touch: touch)
        return true
    }

    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard isEnabled else {
            return false
        }

        super.continueTracking(touch, with: event)
        handle(touch: touch)
        return true
    }

    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        if shouldBecomeFirstResponder && isFirstResponder {
            resignFirstResponder()
        }

        if let touch = touch {
            handle(touch: touch)
        }

        if !continuous {
            sendActions(for: .valueChanged)
        }
    }

    override public func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        if shouldBecomeFirstResponder && isFirstResponder {
            resignFirstResponder()
        }
    }

    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view === self {
            return !isUserInteractionEnabled
        }

        return shouldBeginGestureHandler?(gestureRecognizer) ?? false
    }

    private func handle(touch: UITouch) {
        guard bounds.width > 0, maximumValue > 0 else {
            return
        }

        let location = touch.location(in: self)
        let position = min(max(location.x / bounds.width, 0), 1)
        let adjustedPosition = isRightToLeft ? 1 - position : position
        var newValue = adjustedPosition * maximumValue

        if !allowsHalfStars {
            newValue = ceil(newValue)
        } else if !accurateHalfStars {
            newValue = ceil(2 * newValue) / 2.0
        }

        value = clampedValue(newValue)
    }
}

extension SwiftyStarRatingView {

    override public func accessibilityActivate() -> Bool {
        sendActions(for: .valueChanged)
        return true
    }

    override public func accessibilityIncrement() {
        let increment: CGFloat = allowsHalfStars ? 0.5 : 1.0
        value = clampedValue(value + increment)
    }

    override public func accessibilityDecrement() {
        let decrement: CGFloat = allowsHalfStars ? 0.5 : 1.0
        value = clampedValue(value - decrement)
    }

    private var formattedAccessibilityValue: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        let currentValue = formatter.string(from: NSNumber(value: Double(value))) ?? "\(value)"
        let maxValue = formatter.string(from: NSNumber(value: Double(maximumValue))) ?? "\(maximumValue)"
        return "\(currentValue) of \(maxValue)"
    }
}
