//
//  SHEmailValidationDemoViewController.m
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

#import "DemoViewController.h"
#import "SHEmailValidationTextField.h"
#import "SHEmailValidator.h"

@interface DemoViewController () <UITextFieldDelegate>

@property (nonatomic, strong) SHEmailValidationTextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation DemoViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor grayColor];
    
    UILabel *explanationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width - 20, 80)];
    explanationLabel.backgroundColor = [UIColor clearColor];
    explanationLabel.text = @"Enter an email address into the UITextField, then proceed to the password field for validation. Addresses such as test@gamil.con will produce an autocorrect suggestion.";
    explanationLabel.numberOfLines = 0;
    explanationLabel.font = [UIFont systemFontOfSize:14];
    explanationLabel.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth);
    [self.view addSubview:explanationLabel];
    
    self.emailTextField = [[SHEmailValidationTextField alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width - 20, 44)];
    self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.returnKeyType = UIReturnKeyNext;
    self.emailTextField.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth);
    self.emailTextField.placeholder = @"Email Address";
    self.emailTextField.delegate = self;
    [self.emailTextField setMessage:@"Email address syntax is invalid." forErrorCode:SHInvalidSyntaxError];
    
    // Uncomment these lines to configure the look and feel of the suggestion popup
//    self.emailTextField.bubbleFillColor = [UIColor whiteColor];
//    self.emailTextField.bubbleTitleColor = [UIColor blackColor];
//    self.emailTextField.bubbleSuggestionColor = [UIColor redColor];
    
    [self.view addSubview:self.emailTextField];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 150, self.view.bounds.size.width - 20, 44)];
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth);
    self.passwordTextField.placeholder = @"Password";
    [self.view addSubview:self.passwordTextField];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self.emailTextField hostWillAnimateRotationToInterfaceOrientation:interfaceOrientation];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    return NO;
}

@end
