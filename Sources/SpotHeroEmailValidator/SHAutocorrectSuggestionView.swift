//  Copyright © 2019 SpotHero, Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import UIKit

public typealias SetupBlock = (SHAutocorrectSuggestionView?) -> Void

public class SHAutocorrectSuggestionView: UIView {
    static let cornerRadius: CGFloat = 6
    static let arrowHeight: CGFloat = 12
    static let arrowWidth: CGFloat = 8
    static let maxWidth: CGFloat = 240
    static let dismissButtonWidth: CGFloat = 30
    
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

    public static func defaultFillColor() -> UIColor { return .black }
    public static func defaultTitleColor() -> UIColor { return .white }
    public static func defaultSuggestionColor() -> UIColor { return UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0) }
    
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
        paragraphSuggestedStyle.lineBreakMode = .byWordWrapping
        paragraphSuggestedStyle.alignment = .left
        
        let titleSizeRect = title?.boundingRect(with: CGSize(width: Self.maxWidth - Self.dismissButtonWidth, height: CGFloat.greatestFiniteMagnitude),
                                                options: .usesLineFragmentOrigin,
                                                attributes: [
                                                    .font: self.titleFont,
                                                    .paragraphStyle: paragraphTitleStyle,
                                                    .foregroundColor: UIColor.white,
                                                ],
                                                context: nil)
        
        let suggestionSizeRect = title?.boundingRect(with: CGSize(width: Self.maxWidth - Self.dismissButtonWidth, height: CGFloat.greatestFiniteMagnitude),
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
        
        self.titleRect = CGRect(x: (width - Self.dismissButtonWidth - titleSize.width) / 2, y: Self.cornerRadius, width: titleSize.width, height: titleSize.height)
        self.suggestionRect = CGRect(x: Self.cornerRadius, y: Self.cornerRadius + titleSize.height, width: suggestionSize.width, height: suggestionSize.height)
        
        block?(self)
        
        self.fillColor = self.fillColor ?? Self.defaultFillColor()
        self.titleColor = self.titleColor ?? Self.defaultTitleColor()
        self.suggestionColor = self.suggestionColor ?? Self.defaultSuggestionColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    public override func draw(_ rect: CGRect) {
//        CGSize contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height - kArrowHeight);
//            CGPoint arrowBottom = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height);
//
//            CGMutablePathRef path = CGPathCreateMutable();
//
//            CGPathMoveToPoint(path, NULL, arrowBottom.x, arrowBottom.y);
//            CGPathAddLineToPoint(path, NULL, arrowBottom.x - kArrowWidth, arrowBottom.y - kArrowHeight);
//
//            CGPathAddArcToPoint(path, NULL, 0, contentSize.height, 0, contentSize.height - kCornerRadius, kCornerRadius);
//            CGPathAddArcToPoint(path, NULL, 0, 0, kCornerRadius, 0, kCornerRadius);
//            CGPathAddArcToPoint(path, NULL, contentSize.width, 0, contentSize.width, kCornerRadius, kCornerRadius);
//            CGPathAddArcToPoint(path, NULL, contentSize.width, contentSize.height, contentSize.width - kCornerRadius, contentSize.height, kCornerRadius);
//
//            CGPathAddLineToPoint(path, NULL, arrowBottom.x + kArrowWidth, arrowBottom.y - kArrowHeight);
//
//            CGPathCloseSubpath(path);
//
//            CGContextRef context = UIGraphicsGetCurrentContext();
//
//            CGContextSaveGState(context);
//
//            CGContextAddPath(context, path);
//            CGContextClip(context);
//            CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
//            CGContextFillRect(context, self.bounds);
//
//            CGContextRestoreGState(context);
//            CGPathRelease(path);
//
//            CGFloat separatorX = contentSize.width - kDismissButtonWidth;
//            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
//            CGContextSetLineWidth(context, 1);
//            CGContextMoveToPoint(context, separatorX, 0);
//            CGContextAddLineToPoint(context, separatorX, contentSize.height);
//            CGContextStrokePath(context);
//
//            CGFloat xSize = 12;
//            CGContextSetLineWidth(context, 4);
//            CGContextMoveToPoint(context, separatorX + (kDismissButtonWidth - xSize) / 2, (contentSize.height - xSize) / 2);
//            CGContextAddLineToPoint(context, separatorX + (kDismissButtonWidth + xSize) / 2, (contentSize.height + xSize) / 2);
//            CGContextStrokePath(context);
//            CGContextMoveToPoint(context, separatorX + (kDismissButtonWidth - xSize) / 2, (contentSize.height + xSize) / 2);
//            CGContextAddLineToPoint(context, separatorX + (kDismissButtonWidth + xSize) / 2, (contentSize.height - xSize) / 2);
//            CGContextStrokePath(context);
//
//            [self.titleColor set];
//        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//            NSMutableParagraphStyle * paragraphTitleStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//            paragraphTitleStyle.lineBreakMode = NSLineBreakByWordWrapping;
//            paragraphTitleStyle.alignment = NSTextAlignmentCenter;
//            NSMutableParagraphStyle * paragraphSuggestedStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//            paragraphSuggestedStyle.lineBreakMode = NSLineBreakByCharWrapping;
//            paragraphSuggestedStyle.alignment = NSTextAlignmentLeft;
//            [self.title drawInRect:self.titleRect withAttributes:@{NSFontAttributeName:self.titleFont, NSParagraphStyleAttributeName:paragraphTitleStyle, NSForegroundColorAttributeName:[UIColor whiteColor]}];
//            [self.suggestionColor set];
//            [self.suggestedText drawInRect:self.suggestionRect withAttributes:@{NSFontAttributeName:self.suggestionFont, NSParagraphStyleAttributeName:paragraphSuggestedStyle, NSForegroundColorAttributeName:[SHAutocorrectSuggestionView defaultSuggestionColor]}];
//        #else
//            [self.title drawInRect:self.titleRect withFont:self.titleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
//            [self.suggestionColor set];
//            [self.suggestedText drawInRect:self.suggestionRect withFont:self.suggestionFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
//        #endif
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !touches.isEmpty else {
            return
        }
        
        guard let touchPoint = touches.first?.location(in: self) else {
            return
        }
        
        let viewSize = self.bounds.size
        
        guard touchPoint.x >= 0 && touchPoint.x < viewSize.width && touchPoint.y >= 0 && touchPoint.y < viewSize.height - Self.arrowHeight else {
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

        // Frame is in target.superview coordinates
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
}
