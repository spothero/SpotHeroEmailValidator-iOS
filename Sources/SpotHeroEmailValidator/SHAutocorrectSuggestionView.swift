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

    // + (instancetype)showFromView:(UIView *)target inContainerView:(UIView *)container title:(NSString *)title autocorrectSuggestion:(NSString *)suggestion withSetupBlock:(SetupBlock)block
    
    public static func show(from target: UIView,
                            inContainerView container: UIView?,
                            title: String?,
                            autocorrectSuggestion suggestion: String?,
                            withSetupBlock block: SetupBlock?) -> SHAutocorrectSuggestionView {
        // SHAutocorrectSuggestionView *suggestionView = [[SHAutocorrectSuggestionView alloc] initWithTarget:target title:title autocorrectSuggestion:suggestion withSetupBlock:block];
        
        let suggestionView = SHAutocorrectSuggestionView(target: target,
                                                         title: title,
                                                         autocorrectSuggestion: suggestion,
                                                         withSetupBlock: block)
                                                         
        // [suggestionView showFromView:target inContainerView:container];
        
        suggestionView.show(from: target, inContainerView: container)
        
        return suggestionView
    }
    
    // + (instancetype)showFromView:(UIView *)target title:(NSString *)title autocorrectSuggestion:(NSString *)suggestion withSetupBlock:(SetupBlock)block
    
    public static func show(from target: UIView,
                            title: String?,
                            autocorrectSuggestion suggestion: String?,
                            withSetupBlock block: SetupBlock?) -> SHAutocorrectSuggestionView {
        // return [SHAutocorrectSuggestionView showFromView:target inContainerView:target.superview title:title autocorrectSuggestion:suggestion withSetupBlock:block];
        
        return SHAutocorrectSuggestionView.show(from: target,
                                                inContainerView: target.superview,
                                                title: title,
                                                autocorrectSuggestion: suggestion,
                                                withSetupBlock: block)
    }

    // + (UIColor *)defaultFillColor
    
    public static func defaultFillColor() -> UIColor {
        // return [UIColor blackColor];
        return .black
    }
    
    // + (UIColor *)defaultTitleColor
    
    public static func defaultTitleColor() -> UIColor {
        // return [UIColor whiteColor];
        return .white
        
    }
    
    // + (UIColor *)defaultSuggestionColor
    
    public static func defaultSuggestionColor() -> UIColor {
        // return [UIColor colorWithRed:0.5f green:0.5f blue:1.0f alpha:1.0f];
        return UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0)
    }
    
    // - (instancetype)initWithTarget:(UIView *)target title:(NSString *)title autocorrectSuggestion:(NSString *)suggestion withSetupBlock:(SetupBlock)block
    
    public init(target: UIView, title: String?, autocorrectSuggestion suggestion: String?, withSetupBlock block: SetupBlock?) {
        // self.title = title;
        // self.suggestedText = suggestion;
        // self.titleFont = [UIFont boldSystemFontOfSize:13];
        // self.suggestionFont = [UIFont boldSystemFontOfSize:13];
        
        self.title = title
        self.suggestedText = suggestion
        self.titleFont = UIFont.boldSystemFont(ofSize: 13)
        self.suggestionFont = UIFont.boldSystemFont(ofSize: 13)
        
        super.init(frame: .zero)
        
        // NSMutableParagraphStyle * paragraphTitleStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        // paragraphTitleStyle.lineBreakMode = NSLineBreakByWordWrapping;
        // paragraphTitleStyle.alignment = NSTextAlignmentLeft;
        
        let paragraphTitleStyle = NSMutableParagraphStyle()
        paragraphTitleStyle.lineBreakMode = .byWordWrapping
        paragraphTitleStyle.alignment = .left
        
        // NSMutableParagraphStyle * paragraphSuggestedStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        // paragraphSuggestedStyle.lineBreakMode = NSLineBreakByCharWrapping;
        // paragraphSuggestedStyle.alignment = NSTextAlignmentLeft;
        
        let paragraphSuggestedStyle = NSMutableParagraphStyle()
        paragraphSuggestedStyle.lineBreakMode = .byCharWrapping
        paragraphSuggestedStyle.alignment = .left
        
        // CGRect titleSizeRect = [title boundingRectWithSize:CGSizeMake(kMaxWidth - kDismissButtonWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont, NSParagraphStyleAttributeName:paragraphTitleStyle, NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil];
        
        let titleSizeRect = title?.boundingRect(with: CGSize(width: Self.maxWidth - Self.dismissButtonWidth, height: CGFloat.greatestFiniteMagnitude),
                                                options: .usesLineFragmentOrigin,
                                                attributes: [
                                                    .font: self.titleFont,
                                                    .paragraphStyle: paragraphTitleStyle,
                                                    .foregroundColor: UIColor.white,
                                                ],
                                                context: nil)
        
        // CGRect suggestionSizeRect = [suggestion boundingRectWithSize:CGSizeMake(kMaxWidth - kDismissButtonWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.suggestionFont, NSParagraphStyleAttributeName:paragraphSuggestedStyle, NSForegroundColorAttributeName:[SHAutocorrectSuggestionView defaultSuggestionColor]} context:nil];
        
        let suggestionSizeRect = suggestion?.boundingRect(with: CGSize(width: Self.maxWidth - Self.dismissButtonWidth, height: CGFloat.greatestFiniteMagnitude),
                                                          options: .usesLineFragmentOrigin,
                                                          attributes: [
                                                            .font: self.suggestionFont,
                                                            .paragraphStyle: paragraphSuggestedStyle,
                                                            .foregroundColor: Self.defaultSuggestionColor(),
                                                          ],
                                                          context: nil)
        
        // CGSize titleSize = titleSizeRect.size;
        // CGSize suggestionSize = suggestionSizeRect.size;
                                                     
        guard
            let titleSize = titleSizeRect?.size,
            let suggestionSize = suggestionSizeRect?.size else {
                return
        }
        
        // CGFloat width = MAX(titleSize.width, suggestionSize.width) + kDismissButtonWidth + kCornerRadius * 2;
        // CGFloat height = titleSize.height + suggestionSize.height + kArrowHeight + kCornerRadius * 2;
        // CGFloat left = MAX(10, target.center.x - width / 2);
        // CGFloat top = target.frame.origin.y - height + 4;
        
        let width = max(titleSize.width, suggestionSize.width) + Self.dismissButtonWidth + (Self.cornerRadius * 2)
        let height = titleSize.height + suggestionSize.height + Self.arrowHeight + (Self.cornerRadius * 2)
        let left = max(10, target.center.x - (width / 2))
        let top = target.frame.origin.y - height + 4
        
        // self.frame = CGRectIntegral(CGRectMake(left, top, width, height));
        // self.opaque = NO;
        
        self.frame = CGRect(x: left, y: top, width: width, height: height).integral
        self.isOpaque = false
        
        // self.titleRect = CGRectMake((width - kDismissButtonWidth - titleSize.width) / 2, kCornerRadius, titleSize.width, titleSize.height);
        
        self.titleRect = CGRect(x: (width - Self.dismissButtonWidth - titleSize.width) / 2, y: Self.cornerRadius, width: titleSize.width, height: titleSize.height)
        
        //  self.suggestionRect = CGRectMake(kCornerRadius, kCornerRadius + titleSize.height, suggestionSize.width, suggestionSize.height);
        
        self.suggestionRect = CGRect(x: Self.cornerRadius, y: Self.cornerRadius + titleSize.height, width: suggestionSize.width, height: suggestionSize.height)
        
        // if (block) {
        //     block(self);
        // }
        
        block?(self)
        
        // if (!self.fillColor) {
        //     self.fillColor = [SHAutocorrectSuggestionView defaultFillColor];
        // }
        
        self.fillColor = self.fillColor ?? Self.defaultFillColor()
        
        // if (!self.titleColor) {
        //     self.titleColor = [SHAutocorrectSuggestionView defaultTitleColor];
        // }
        
        self.titleColor = self.titleColor ?? Self.defaultTitleColor()
        
        // if (!self.suggestionColor) {
        //     self.suggestionColor = [SHAutocorrectSuggestionView defaultSuggestionColor];
        // }
        
        self.suggestionColor = self.suggestionColor ?? Self.defaultSuggestionColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - (void)drawRect:(CGRect)rect
    
    public override func draw(_ rect: CGRect) {
        // CGSize contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height - kArrowHeight);
        // CGPoint arrowBottom = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height);
        
        let contentSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height - Self.arrowHeight)
        let arrowBottom = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height)

        // CGMutablePathRef path = CGPathCreateMutable();
        
        let path = CGMutablePath()
        
        // CGPathMoveToPoint(path, NULL, arrowBottom.x, arrowBottom.y);
        // CGPathAddLineToPoint(path, NULL, arrowBottom.x - kArrowWidth, arrowBottom.y - kArrowHeight);

        path.move(to: CGPoint(x: arrowBottom.x, y: arrowBottom.y))
        path.addLine(to: CGPoint(x: arrowBottom.x - Self.arrowWidth, y: arrowBottom.y - Self.arrowHeight))

        // CGPathAddArcToPoint(path, NULL, 0, contentSize.height, 0, contentSize.height - kCornerRadius, kCornerRadius);
        // CGPathAddArcToPoint(path, NULL, 0, 0, kCornerRadius, 0, kCornerRadius);
        // CGPathAddArcToPoint(path, NULL, contentSize.width, 0, contentSize.width, kCornerRadius, kCornerRadius);
        // CGPathAddArcToPoint(path, NULL, contentSize.width, contentSize.height, contentSize.width - kCornerRadius, contentSize.height, kCornerRadius);
        
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
        
        // CGPathAddLineToPoint(path, NULL, arrowBottom.x + kArrowWidth, arrowBottom.y - kArrowHeight);

        path.addLine(to: CGPoint(x: arrowBottom.x + Self.arrowWidth, y: arrowBottom.y - Self.arrowHeight))
        
        // CGPathCloseSubpath(path);

        path.closeSubpath()
        
        // CGContextRef context = UIGraphicsGetCurrentContext();

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // CGContextSaveGState(context);

        context.saveGState()
        
        // CGContextAddPath(context, path);
        // CGContextClip(context);

        context.addPath(path)
        context.clip()
        
        // CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
        // CGContextFillRect(context, self.bounds);
        
        let fillColor = self.fillColor ?? Self.defaultFillColor()
        
        context.setFillColor(fillColor.cgColor)
        context.fill(bounds)
        
        // CGContextRestoreGState(context);

        context.restoreGState()
        
        // CGPathRelease(path);
        // There's no need to release in Swift!
        
        // CGFloat separatorX = contentSize.width - kDismissButtonWidth;
        // CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        // CGContextSetLineWidth(context, 1);
        // CGContextMoveToPoint(context, separatorX, 0);
        // CGContextAddLineToPoint(context, separatorX, contentSize.height);
        // CGContextStrokePath(context);

        let separatorX = contentSize.width - Self.dismissButtonWidth
        context.setStrokeColor(UIColor.gray.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: separatorX, y: 0))
        context.addLine(to: CGPoint(x: separatorX, y: contentSize.height))
        context.strokePath()
        
        // CGFloat xSize = 12;
        
        let xSize: CGFloat = 12
        
        // CGContextSetLineWidth(context, 4);
        
        context.setLineWidth(4)
        
        // CGContextMoveToPoint(context, separatorX + (kDismissButtonWidth - xSize) / 2, (contentSize.height - xSize) / 2);
        // CGContextAddLineToPoint(context, separatorX + (kDismissButtonWidth + xSize) / 2, (contentSize.height + xSize) / 2);
        // CGContextStrokePath(context);
        
        context.move(to: CGPoint(x: separatorX + (Self.dismissButtonWidth - xSize) / 2, y: (contentSize.height - xSize) / 2))
        context.addLine(to: CGPoint(x: separatorX + (Self.dismissButtonWidth + xSize) / 2, y: (contentSize.height + xSize) / 2))
        context.strokePath()
        
        // CGContextMoveToPoint(context, separatorX + (kDismissButtonWidth - xSize) / 2, (contentSize.height + xSize) / 2);
        // CGContextAddLineToPoint(context, separatorX + (kDismissButtonWidth + xSize) / 2, (contentSize.height - xSize) / 2);
        // CGContextStrokePath(context);
        
        context.move(to: CGPoint(x: separatorX + (Self.dismissButtonWidth - xSize) / 2, y: (contentSize.height + xSize) / 2))
        context.addLine(to: CGPoint(x: separatorX + (Self.dismissButtonWidth + xSize) / 2, y: (contentSize.height - xSize) / 2))
        context.strokePath()
        
        // NSMutableParagraphStyle * paragraphTitleStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        // paragraphTitleStyle.lineBreakMode = NSLineBreakByWordWrapping;
        // paragraphTitleStyle.alignment = NSTextAlignmentCenter;

        let paragraphTitleStyle = NSMutableParagraphStyle()
        paragraphTitleStyle.lineBreakMode = .byWordWrapping
        paragraphTitleStyle.alignment = .center
        
        // NSMutableParagraphStyle * paragraphSuggestedStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        // paragraphSuggestedStyle.lineBreakMode = NSLineBreakByCharWrapping;
        // paragraphSuggestedStyle.alignment = NSTextAlignmentLeft;
        
        let paragraphSuggestedStyle = NSMutableParagraphStyle()
        paragraphSuggestedStyle.lineBreakMode = .byCharWrapping
        paragraphSuggestedStyle.alignment = .left
        
        if let title = self.title, let titleRect = self.titleRect {
            // [self.titleColor set];
            
            self.titleColor?.set()
            
            // self.title drawInRect:self.titleRect withAttributes:@{NSFontAttributeName:self.titleFont, NSParagraphStyleAttributeName:paragraphTitleStyle, NSForegroundColorAttributeName:[UIColor whiteColor]}];
            
            title.draw(in: titleRect, withAttributes: [
                .font: self.titleFont,
                .paragraphStyle: paragraphTitleStyle,
                .foregroundColor: UIColor.white
            ])
        }
        
        if let suggestedText = self.suggestedText, let suggestionRect = self.suggestionRect {
            // [self.suggestionColor set];
            
            self.suggestionColor?.set()
            
            // [self.suggestedText drawInRect:self.suggestionRect withAttributes:@{NSFontAttributeName:self.suggestionFont, NSParagraphStyleAttributeName:paragraphSuggestedStyle, NSForegroundColorAttributeName:[SHAutocorrectSuggestionView defaultSuggestionColor]}];
            
            suggestedText.draw(in: suggestionRect, withAttributes: [
                .font: self.suggestionFont,
                .paragraphStyle: paragraphSuggestedStyle,
                .foregroundColor: Self.defaultSuggestionColor()
            ])
        }
    }
    
    // - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if (touches.count == 1) {
            //     <converted to guard to remove nesting>
        // }
        
        guard touches.count == 1 else {
            return
        }
        
        // UITouch *touch = [touches anyObject];
        // CGPoint touchPoint = [touch locationInView:self];
        
        guard let touchPoint = touches.first?.location(in: self) else {
            return
        }
        
        // CGSize viewSize = self.bounds.size;
        
        let viewSize = self.bounds.size
        
        // if (touchPoint.x >= 0 && touchPoint.x < viewSize.width && touchPoint.y >= 0 && touchPoint.y < viewSize.height - kArrowHeight) {
        //     <converted to guard to remove nesting>
        // }
        
        guard touchPoint.x >= 0 && touchPoint.x < viewSize.width && touchPoint.y >= 0 && touchPoint.y < viewSize.height - Self.arrowHeight else {
            return
        }
        
        // if (touchPoint.x <= viewSize.width - kDismissButtonWidth && self.suggestedText) {
        //     [self.delegate suggestionView:self wasDismissedWithAccepted:YES];
        //     [self dismiss];
        // } else {
        //     [self.delegate suggestionView:self wasDismissedWithAccepted:NO];
        //     [self dismiss];
        // }
        
        let wasDismissedWithAccepted = touchPoint.x <= viewSize.width - Self.dismissButtonWidth && self.suggestedText != nil
        
        self.delegate?.suggestionView(self, wasDismissedWithAccepted: wasDismissedWithAccepted)
        self.dismiss()
    }
    
    // - (void)showFromView:(UIView *)target inContainerView:(UIView *)container
    
    public func show(from target: UIView, inContainerView container: UIView?) {
        
        // self.target = target;
        
        self.target = target
        
        // self.alpha = 0.2;
        // self.transform = CGAffineTransformMakeScale(0.6, 0.6);
        
        self.alpha = 0.2
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        // Frame is in target.superview coordinates
        
        // self.frame = [target.superview convertRect:self.frame toView:container];
        // [container addSubview:self];
        
        self.frame = target.superview?.convert(self.frame, to: container) ?? .zero
        container?.addSubview(self)
        
        // [UIView animateWithDuration:0.2
        //                  animations:^{
        //                      self.alpha = 1;
        //                      self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        //                  }
        //                  completion:^(BOOL finished) {
        //                      [UIView animateWithDuration:0.1
        //                                       animations:^{
        //                                           self.transform = CGAffineTransformIdentity;
        //                                       }];
        //                  }];
        
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

    // - (void)updatePosition
    
    public func updatePosition() {
        guard
            let target = self.target,
            let targetSuperview = target.superview else {
                return
        }
        
        // CGFloat width = self.bounds.size.width;
        // CGFloat height = self.bounds.size.height;
        // CGFloat left = MAX(10, self.target.center.x - width / 2);
        // CGFloat top = self.target.frame.origin.y - height;
        
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        let left = max(10, target.center.x - (width / 2))
        let top = target.frame.origin.y - height
        
        // self.frame = CGRectIntegral([self.target.superview convertRect:CGRectMake(left, top, width, height) toView:self.superview]);
        
        self.frame = targetSuperview.convert(CGRect(x: left, y: top, width: width, height: height), to: self.superview).integral
    }
    
    // - (void)dismiss
    
    public func dismiss() {
        // [UIView animateWithDuration:0.1
        //                  animations:^{
        //                      self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        //                }
        //                completion:^(BOOL finished) {
        //                    [UIView animateWithDuration:0.2
        //                                     animations:^{
        //                                         self.alpha = 0.2;
        //                                         self.transform = CGAffineTransformMakeScale(0.6, 0.6);
        //                                     }
        //                                     completion:^(BOOL innerFinished) {
        //                                         [self removeFromSuperview];
        //                                         self.target = nil;
        //                                     }];
        //                }];
        
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
