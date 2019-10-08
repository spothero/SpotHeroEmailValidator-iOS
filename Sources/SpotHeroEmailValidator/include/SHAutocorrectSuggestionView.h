//
//  SHAutocorrectSuggestionView.h
//  SHEmailValidator
//
//  Created by Eric Kuck on 10/12/13.
//  Copyright (c) 2013 SpotHero.
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

#import <UIKit/UIKit.h>

@class SHAutocorrectSuggestionView;

typedef void (^SetupBlock)(SHAutocorrectSuggestionView *view);

@protocol AutocorrectSuggestionViewDelegate
- (void)suggestionView:(SHAutocorrectSuggestionView *)suggestionView wasDismissedWithAccepted:(BOOL)accepted;
@end

@interface SHAutocorrectSuggestionView : UIView

@property (nonatomic, weak) id<AutocorrectSuggestionViewDelegate> delegate;
@property (nonatomic, strong) NSString *suggestedText;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *suggestionColor;

+ (UIColor *)defaultFillColor;
+ (UIColor *)defaultTitleColor;
+ (UIColor *)defaultSuggestionColor;

+ (instancetype)showFromView:(UIView *)target title:(NSString *)title autocorrectSuggestion:(NSString *)suggestion withSetupBlock:(SetupBlock)block;
+ (instancetype)showFromView:(UIView *)target inContainerView:(UIView *)container title:(NSString *)title autocorrectSuggestion:(NSString *)suggestion withSetupBlock:(SetupBlock)block;
- (void)updatePosition;
- (void)dismiss;

@end
