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
    private var titleFront: UIFont?
    private var suggestionFont: UIFont?
    private var title: String?
    private var titleRect: CGRect?
    private var suggestionRect: CGRect?

    public static func defaultFillColor() -> UIColor { return .black }
    public static func defaultTitleColor() -> UIColor { return .white }
    public static func defaultSuggestionColor() -> UIColor { return UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0) }
    
    public init(target: UIView, title: String?, autocorrectSuggestion suggestion: String?, withSetupBlock block: SetupBlock) {
//        if ((self = [super init])) {
//                self.title = title;
//                self.suggestedText = suggestion;
//                self.titleFont = [UIFont boldSystemFontOfSize:13];
//                self.suggestionFont = [UIFont boldSystemFontOfSize:13];
//        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//                NSMutableParagraphStyle * paragraphTitleStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//                paragraphTitleStyle.lineBreakMode = NSLineBreakByWordWrapping;
//                paragraphTitleStyle.alignment = NSTextAlignmentLeft;
//
//                NSMutableParagraphStyle * paragraphSuggestedStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//                paragraphSuggestedStyle.lineBreakMode = NSLineBreakByCharWrapping;
//                paragraphSuggestedStyle.alignment = NSTextAlignmentLeft;
//
//                CGRect titleSizeRect = [title boundingRectWithSize:CGSizeMake(kMaxWidth - kDismissButtonWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont, NSParagraphStyleAttributeName:paragraphTitleStyle, NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil];
//                CGSize titleSize = titleSizeRect.size;
//
//                CGRect suggestionSizeRect = [suggestion boundingRectWithSize:CGSizeMake(kMaxWidth - kDismissButtonWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.suggestionFont, NSParagraphStyleAttributeName:paragraphSuggestedStyle, NSForegroundColorAttributeName:[SHAutocorrectSuggestionView defaultSuggestionColor]} context:nil];
//                CGSize suggestionSize = suggestionSizeRect.size;
//        #else
//                CGSize titleSize = [title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(kMaxWidth - kDismissButtonWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//                CGSize suggestionSize = [suggestion sizeWithFont:self.suggestionFont constrainedToSize:CGSizeMake(kMaxWidth - kDismissButtonWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
//        #endif
//                CGFloat width = MAX(titleSize.width, suggestionSize.width) + kDismissButtonWidth + kCornerRadius * 2;
//                CGFloat height = titleSize.height + suggestionSize.height + kArrowHeight + kCornerRadius * 2;
//                CGFloat left = MAX(10, target.center.x - width / 2);
//                CGFloat top = target.frame.origin.y - height + 4;
//
//                self.frame = CGRectIntegral(CGRectMake(left, top, width, height));
//                self.opaque = NO;
//
//                self.titleRect = CGRectMake((width - kDismissButtonWidth - titleSize.width) / 2, kCornerRadius, titleSize.width, titleSize.height);
//                self.suggestionRect = CGRectMake(kCornerRadius, kCornerRadius + titleSize.height, suggestionSize.width, suggestionSize.height);
//
//                if (block) {
//                    block(self);
//                }
//
//                if (!self.fillColor) {
//                    self.fillColor = [SHAutocorrectSuggestionView defaultFillColor];
//                }
//
//                if (!self.titleColor) {
//                    self.titleColor = [SHAutocorrectSuggestionView defaultTitleColor];
//                }
//
//                if (!self.suggestionColor) {
//                    self.suggestionColor = [SHAutocorrectSuggestionView defaultSuggestionColor];
//                }
//            }
//            return self;
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func show(from target: UIView,
                            title: String?,
                            autocorrectSuggestion suggestion: String?,
                            withSetupBlock block: SetupBlock) -> SHAutocorrectSuggestionView {
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
                            withSetupBlock block: SetupBlock) -> SHAutocorrectSuggestionView {
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
//        self.target = target;
//
//        self.alpha = 0.2;
//        self.transform = CGAffineTransformMakeScale(0.6, 0.6);
//
//        // Frame is in target.superview coordinates
//        self.frame = [target.superview convertRect:self.frame toView:container];
//        [container addSubview:self];
//
//        [UIView animateWithDuration:0.2
//                         animations:^{
//                             self.alpha = 1;
//                             self.transform = CGAffineTransformMakeScale(1.1, 1.1);
//                         }
//                         completion:^(BOOL finished) {
//                             [UIView animateWithDuration:0.1
//                                              animations:^{
//                                                  self.transform = CGAffineTransformIdentity;
//                                              }];
//                         }];
    }

    public func updatePosition() {
//         CGFloat width = self.bounds.size.width;
//         CGFloat height = self.bounds.size.height;
//         CGFloat left = MAX(10, self.target.center.x - width / 2);
//         CGFloat top = self.target.frame.origin.y - height;
//
//         self.frame = CGRectIntegral([self.target.superview convertRect:CGRectMake(left, top, width, height) toView:self.superview]);
    }

    public func dismiss() {
//        [UIView animateWithDuration:0.1
//                         animations:^{
//                             self.transform = CGAffineTransformMakeScale(1.1, 1.1);
//                         }
//                         completion:^(BOOL finished) {
//                             [UIView animateWithDuration:0.2
//                                              animations:^{
//                                                  self.alpha = 0.2;
//                                                  self.transform = CGAffineTransformMakeScale(0.6, 0.6);
//                                              }
//                                              completion:^(BOOL innerFinished) {
//                                                  [self removeFromSuperview];
//                                                  self.target = nil;
//                                              }];
//                         }];
    }
}
