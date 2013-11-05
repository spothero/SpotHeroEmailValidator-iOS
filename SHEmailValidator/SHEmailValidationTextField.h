//
//  SHEmailValidationTextField.h
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

@interface SHEmailValidationTextField : UITextField

@property (nonatomic, strong) NSString *defaultErrorMessage;
@property (nonatomic, strong) NSString *messageForSuggestion;
@property (nonatomic, strong) UIColor *bubbleFillColor;
@property (nonatomic, strong) UIColor *bubbleTitleColor;
@property (nonatomic, strong) UIColor *bubbleSuggestionColor;

- (void)dismissSuggestionView;
- (void)validateInput;
- (void)hostWillAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)setMessage:(NSString *)message forErrorCode:(NSInteger)errorCode;

@end
