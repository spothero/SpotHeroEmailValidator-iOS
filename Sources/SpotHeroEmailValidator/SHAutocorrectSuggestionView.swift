// Copyright © 2021 SpotHero, Inc. All rights reserved.

#if canImport(UIKit)

    import Foundation
    import UIKit

    /// Completion block for when the autocorrect suggestion view is shown.
    public typealias SetupBlock = (SHAutocorrectSuggestionView?) -> Void

    // Obj-C code is documented above every call or signature for ease of maintenance and identifying any escaped defects.
    // As we refactor the behavior and logic and feel more confident in the translation to Swift, we'll remove the commented code blocks.

    public class SHAutocorrectSuggestionView: UIView {
        private static let cornerRadius: CGFloat = 6
        private static let arrowHeight: CGFloat = 12
        private static let arrowWidth: CGFloat = 8
        private static let maxWidth: CGFloat = 240
        private static let dismissButtonWidth: CGFloat = 30
    
        weak var delegate: AutocorrectSuggestionViewDelegate?

        public var suggestedText: String?
        public var fillColor: UIColor?
        public var titleColor: UIColor?
        public var suggestionColor: UIColor?
    
        private var target: UIView?
        private var titleRect: CGRect?
        private var suggestionRect: CGRect?
    
        private let titleFont: UIFont
        private let suggestionFont: UIFont
        private let title: String?
    
        public static func show(from target: UIView,
                                inContainerView container: UIView?,
                                title: String?,
                                autocorrectSuggestion suggestion: String?,
                                withSetupBlock block: SetupBlock?) -> SHAutocorrectSuggestionView {
            let suggestionView = SHAutocorrectSuggestionView(target: target,
                                                             title: title,
                                                             autocorrectSuggestion: suggestion,
                                                             withSetupBlock: block)
        
            suggestionView.show(from: target, inContainerView: container)
        
            return suggestionView
        }
    
        public static func show(from target: UIView,
                                title: String?,
                                autocorrectSuggestion suggestion: String?,
                                withSetupBlock block: SetupBlock?) -> SHAutocorrectSuggestionView {
            return SHAutocorrectSuggestionView.show(from: target,
                                                    inContainerView: target.superview,
                                                    title: title,
                                                    autocorrectSuggestion: suggestion,
                                                    withSetupBlock: block)
        }
    
        public static func defaultFillColor() -> UIColor {
            return .black
        }
    
        public static func defaultTitleColor() -> UIColor {
            return .white
        }
    
        public static func defaultSuggestionColor() -> UIColor {
            return UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0)
        }
    
        public init(target: UIView, title: String?, autocorrectSuggestion suggestion: String?, withSetupBlock block: SetupBlock?) {
            self.title = title
            self.suggestedText = suggestion
            self.titleFont = UIFont.boldSystemFont(ofSize: 13)
            self.suggestionFont = UIFont.boldSystemFont(ofSize: 13)
        
            super.init(frame: .zero)
        
            let paragraphTitleStyle = NSMutableParagraphStyle()
            paragraphTitleStyle.lineBreakMode = .byWordWrapping
            paragraphTitleStyle.alignment = .left
        
            let paragraphSuggestedStyle = NSMutableParagraphStyle()
            paragraphSuggestedStyle.lineBreakMode = .byCharWrapping
            paragraphSuggestedStyle.alignment = .left
        
            let titleSizeRect = title?.boundingRect(with: CGSize(width: Self.maxWidth - Self.dismissButtonWidth,
                                                                 height: CGFloat.greatestFiniteMagnitude),
                                                    options: .usesLineFragmentOrigin,
                                                    attributes: [
                                                        .font: self.titleFont,
                                                        .paragraphStyle: paragraphTitleStyle,
                                                        .foregroundColor: UIColor.white,
                                                    ],
                                                    context: nil)
        
            let suggestionSizeRect = suggestion?.boundingRect(with: CGSize(width: Self.maxWidth - Self.dismissButtonWidth,
                                                                           height: CGFloat.greatestFiniteMagnitude),
                                                              options: .usesLineFragmentOrigin,
                                                              attributes: [
                                                                  .font: self.suggestionFont,
                                                                  .paragraphStyle: paragraphSuggestedStyle,
                                                                  .foregroundColor: Self.defaultSuggestionColor(),
                                                              ],
                                                              context: nil)
                                                     
            guard
                let titleSize = titleSizeRect?.size,
                let suggestionSize = suggestionSizeRect?.size else {
                return
            }
        
            let width = max(titleSize.width, suggestionSize.width) + Self.dismissButtonWidth + (Self.cornerRadius * 2)
            let height = titleSize.height + suggestionSize.height + Self.arrowHeight + (Self.cornerRadius * 2)
            let left = max(10, target.center.x - (width / 2))
            let top = target.frame.origin.y - height + 4
        
            self.frame = CGRect(x: left, y: top, width: width, height: height).integral
            self.isOpaque = false
        
            self.titleRect = CGRect(x: (width - Self.dismissButtonWidth - titleSize.width) / 2,
                                    y: Self.cornerRadius,
                                    width: titleSize.width,
                                    height: titleSize.height)
        
            self.suggestionRect = CGRect(x: Self.cornerRadius,
                                         y: Self.cornerRadius + titleSize.height,
                                         width: suggestionSize.width,
                                         height: suggestionSize.height)
        
            block?(self)
        
            self.fillColor = self.fillColor ?? Self.defaultFillColor()
        
            self.titleColor = self.titleColor ?? Self.defaultTitleColor()
        
            self.suggestionColor = self.suggestionColor ?? Self.defaultSuggestionColor()
        }
    
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
        override public func draw(_ rect: CGRect) {
            let contentSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height - Self.arrowHeight)
            let arrowBottom = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height)

            let path = CGMutablePath()
        
            path.move(to: CGPoint(x: arrowBottom.x, y: arrowBottom.y))
            path.addLine(to: CGPoint(x: arrowBottom.x - Self.arrowWidth, y: arrowBottom.y - Self.arrowHeight))

            path.addArc(tangent1End: CGPoint(x: 0, y: contentSize.height),
                        tangent2End: CGPoint(x: 0, y: contentSize.height - Self.cornerRadius),
                        radius: Self.cornerRadius)
            path.addArc(tangent1End: CGPoint(x: 0, y: 0),
                        tangent2End: CGPoint(x: Self.cornerRadius, y: 0),
                        radius: Self.cornerRadius)
            path.addArc(tangent1End: CGPoint(x: contentSize.width, y: 0),
                        tangent2End: CGPoint(x: contentSize.width, y: Self.cornerRadius),
                        radius: Self.cornerRadius)
            path.addArc(tangent1End: CGPoint(x: contentSize.width, y: contentSize.height),
                        tangent2End: CGPoint(x: contentSize.width - Self.cornerRadius, y: contentSize.height),
                        radius: Self.cornerRadius)
        
            path.addLine(to: CGPoint(x: arrowBottom.x + Self.arrowWidth, y: arrowBottom.y - Self.arrowHeight))
        
            path.closeSubpath()
        
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
        
            context.saveGState()
        
            context.addPath(path)
            context.clip()
        
            let fillColor = self.fillColor ?? Self.defaultFillColor()
        
            context.setFillColor(fillColor.cgColor)
            context.fill(bounds)
        
            context.restoreGState()

            let separatorX = contentSize.width - Self.dismissButtonWidth
            context.setStrokeColor(UIColor.gray.cgColor)
            context.setLineWidth(1)
            context.move(to: CGPoint(x: separatorX, y: 0))
            context.addLine(to: CGPoint(x: separatorX, y: contentSize.height))
            context.strokePath()
        
            let xSize: CGFloat = 12
        
            context.setLineWidth(4)
        
            context.move(to: CGPoint(x: separatorX + (Self.dismissButtonWidth - xSize) / 2, y: (contentSize.height - xSize) / 2))
            context.addLine(to: CGPoint(x: separatorX + (Self.dismissButtonWidth + xSize) / 2, y: (contentSize.height + xSize) / 2))
            context.strokePath()
        
            context.move(to: CGPoint(x: separatorX + (Self.dismissButtonWidth - xSize) / 2, y: (contentSize.height + xSize) / 2))
            context.addLine(to: CGPoint(x: separatorX + (Self.dismissButtonWidth + xSize) / 2, y: (contentSize.height - xSize) / 2))
            context.strokePath()

            let paragraphTitleStyle = NSMutableParagraphStyle()
            paragraphTitleStyle.lineBreakMode = .byWordWrapping
            paragraphTitleStyle.alignment = .center
        
            let paragraphSuggestedStyle = NSMutableParagraphStyle()
            paragraphSuggestedStyle.lineBreakMode = .byCharWrapping
            paragraphSuggestedStyle.alignment = .left
        
            if let title = self.title, let titleRect = self.titleRect {
                self.titleColor?.set()
            
                title.draw(in: titleRect, withAttributes: [
                    .font: self.titleFont,
                    .paragraphStyle: paragraphTitleStyle,
                    .foregroundColor: UIColor.white,
                ])
            }
        
            if let suggestedText = self.suggestedText, let suggestionRect = self.suggestionRect {
                self.suggestionColor?.set()
            
                suggestedText.draw(in: suggestionRect, withAttributes: [
                    .font: self.suggestionFont,
                    .paragraphStyle: paragraphSuggestedStyle,
                    .foregroundColor: Self.defaultSuggestionColor(),
                ])
            }
        }
    
        override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard touches.count == 1 else {
                return
            }
        
            guard let touchPoint = touches.first?.location(in: self) else {
                return
            }
        
            let viewSize = self.bounds.size
        
            guard touchPoint.x >= 0, touchPoint.x < viewSize.width, touchPoint.y >= 0, touchPoint.y < viewSize.height - Self.arrowHeight else {
                return
            }
        
            let wasDismissedWithAccepted = touchPoint.x <= viewSize.width - Self.dismissButtonWidth && self.suggestedText != nil
        
            self.delegate?.suggestionView(self, wasDismissedWithAccepted: wasDismissedWithAccepted)
            self.dismiss()
        }
    
        public func show(from target: UIView, inContainerView container: UIView?) {
            self.target = target
        
            self.alpha = 0.2
            self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

            self.frame = target.superview?.convert(self.frame, to: container) ?? .zero
            container?.addSubview(self)
        
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.alpha = 1
                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                },
                completion: { _ in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.transform = .identity
                    })
                }
            )
        }
    
        public func updatePosition() {
            guard
                let target = self.target,
                let targetSuperview = target.superview else {
                return
            }
        
            let width = self.bounds.size.width
            let height = self.bounds.size.height
            let left = max(10, target.center.x - (width / 2))
            let top = target.frame.origin.y - height
        
            self.frame = targetSuperview.convert(CGRect(x: left, y: top, width: width, height: height), to: self.superview).integral
        }
    
        public func dismiss() {
            UIView.animate(
                withDuration: 0.1,
                animations: {
                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                },
                completion: { _ in
                    UIView.animate(
                        withDuration: 0.2,
                        animations: {
                            self.alpha = 0.2
                            self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                        },
                        completion: { _ in
                            self.removeFromSuperview()
                            self.target = nil
                        }
                    )
                }
            )
        }
    }

#endif
