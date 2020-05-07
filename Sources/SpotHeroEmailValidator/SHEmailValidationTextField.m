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

#include <TargetConditionals.h>

#if TARGET_OS_UIKITFORMAC || !TARGET_OS_OSX

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "include/SHEmailValidationTextField.h"
#import "include/SHAutocorrectSuggestionView.h"
#import <SpotHeroEmailValidator/SpotHeroEmailValidator-Swift.h>

@interface SHEmailValidationTextField () <AutocorrectSuggestionViewDelegate>

@property (nonatomic, strong) SHAutocorrectSuggestionView *suggestionView;
@property (nonatomic, strong) SpotHeroEmailValidator *emailValidator;
@property (nonatomic, strong) EmailTextFieldDelegate *delegateProxy;
@property (nonatomic, strong) NSMutableDictionary *messageDictionary;

@end

@implementation SHEmailValidationTextField

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.delegateProxy = [[EmailTextFieldDelegate alloc] initWithTarget:self];
    self.delegate = self.delegateProxy;
    self.emailValidator = [SpotHeroEmailValidator shared];
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.keyboardType = UIKeyboardTypeEmailAddress;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.messageDictionary = [NSMutableDictionary dictionary];
    self.defaultErrorMessage = @"Please enter a valid email address";
    self.messageForSuggestion = @"Did you mean";

    self.bubbleFillColor = [SHAutocorrectSuggestionView defaultFillColor];
    self.bubbleTitleColor = [SHAutocorrectSuggestionView defaultTitleColor];
    self.bubbleSuggestionColor = [SHAutocorrectSuggestionView defaultSuggestionColor];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    if ([delegate isKindOfClass:[EmailTextFieldDelegate class]]) {
        [super setDelegate:delegate];
    } else {
        self.delegateProxy.subDelegate = delegate;
    }
}

- (void)validateInput
{
    if (self.text.length > 0) {
        NSError *error;
        
        SHValidationResult *validationResult = [self.emailValidator validateAndAutocorrectWithEmailAddress:self.text error:&error];

        if (error) {
            self.validationError = error;

            NSString *message = self.messageDictionary[@(error.code)];
            if (!message) {
                message = self.defaultErrorMessage;
            }
            self.suggestionView = [SHAutocorrectSuggestionView showFromView:self title:message autocorrectSuggestion:nil withSetupBlock:^(SHAutocorrectSuggestionView *view) {
                view.fillColor = self.bubbleFillColor;
                view.titleColor = self.bubbleTitleColor;
                view.suggestionColor = self.bubbleSuggestionColor;
            }];
            self.suggestionView.delegate = self;
        } else {
            self.validationError = nil;

            if (validationResult.autocorrectSuggestion) {
                self.suggestionView = [SHAutocorrectSuggestionView showFromView:self title:self.messageForSuggestion autocorrectSuggestion:validationResult.autocorrectSuggestion withSetupBlock:^(SHAutocorrectSuggestionView *view) {
                    view.fillColor = self.bubbleFillColor;
                    view.titleColor = self.bubbleTitleColor;
                    view.suggestionColor = self.bubbleSuggestionColor;
                }];
                self.suggestionView.delegate = self;
            }
        }
    }
}

#if !TARGET_OS_TV
- (void)hostWillAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self.suggestionView updatePosition];
}
#endif

- (void)dismissSuggestionView
{
    [self.suggestionView dismiss];
}

- (void)setMessage:(NSString *)message forErrorCode:(NSInteger)errorCode
{
    self.messageDictionary[@(errorCode)] = message;
}

- (void)setBubbleFillColor:(UIColor *)bubbleFillColor
{
    _bubbleFillColor = bubbleFillColor;
    self.suggestionView.fillColor = bubbleFillColor;
}

- (void)setBubbleTitleColor:(UIColor *)bubbleTitleColor
{
    _bubbleTitleColor = bubbleTitleColor;
    self.suggestionView.titleColor = bubbleTitleColor;
}

- (void)setBubbleSuggestionColor:(UIColor *)bubbleSuggestionColor
{
    _bubbleSuggestionColor = bubbleSuggestionColor;
    self.suggestionView.suggestionColor = bubbleSuggestionColor;
}

#pragma mark
#pragma mark - AutocorrectSuggestionViewDelegate methods
- (void)suggestionView:(SHAutocorrectSuggestionView *)suggestionView wasDismissedWithAccepted:(BOOL)accepted
{
    if (accepted) {
        self.text = suggestionView.suggestedText;
    }
}

@end

#endif
