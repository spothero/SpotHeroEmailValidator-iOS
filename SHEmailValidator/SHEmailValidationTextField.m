//
//  SHEmailValidationTextField.m
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

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "SHEmailValidationTextField.h"
#import "SHEmailValidator.h"
#import "SHAutocorrectSuggestionView.h"

@interface EmailTextFieldDelegate : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) SHEmailValidationTextField *target;
@property (nonatomic, weak) id<UITextFieldDelegate> subDelegate;

@end

@implementation EmailTextFieldDelegate

- (instancetype)initWithTarget:(SHEmailValidationTextField *)target
{
    if ((self = [super init])) {
        self.target = target;
    }
    return self;
}

#pragma mark
#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.target dismissSuggestionView];
    
    if ([self.subDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.subDelegate textFieldShouldBeginEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.subDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.subDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.target validateInput];
    if ([self.subDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.subDelegate textFieldShouldEndEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.subDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.subDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.subDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.subDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.subDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.subDelegate textFieldShouldClear:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.subDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.subDelegate textFieldShouldReturn:textField];
    } else {
        return YES;
    }
}

@end

@interface SHEmailValidationTextField () <AutocorrectSuggestionViewDelegate>

@property (nonatomic, strong) SHAutocorrectSuggestionView *suggestionView;
@property (nonatomic, strong) SHEmailValidator *emailValidator;
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
    self.emailValidator = [SHEmailValidator validator];
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
        SHValidationResult *validationResult = [self.emailValidator validateAndAutocorrectEmailAddress:self.text withError:&error];
        
        if (error) {
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

- (void)hostWillAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self.suggestionView updatePosition];
}

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
