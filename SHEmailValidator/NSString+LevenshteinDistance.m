//
//  NSString+LevenshteinDistance.m
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

#import "NSString+LevenshteinDistance.h"

@implementation NSString (LevenshteinDistance)

- (NSUInteger)levenshteinDistanceFromString:(NSString *)otherString
{
    NSInteger *d;
	
	NSUInteger length = self.length;
	NSUInteger otherLength = otherString.length;
	
	if (length != 0 && otherLength != 0) {
		d = malloc(sizeof(NSUInteger) * (++length) * (++otherLength));
		
		for (int i = 0; i < length; i++) {
			d[i] = i;
        }
		
		for(int i = 0; i < otherLength; i++) {
			d[i * length] = i;
        }
		
		for (int i = 1; i < length; i++) {
			for (int j = 1; j < otherLength; j++) {
				BOOL match = [self characterAtIndex:i-1] == [otherString characterAtIndex:j-1];
				d[j * length + i] = MIN(d[(j - 1) * length + i] + 1, MIN(d[j * length + i - 1] +  1, d[(j - 1) * length + i -1] + (match ? 0 : 1)));
			}
		}
        
		NSUInteger distance = d[length * otherLength - 1];
		free(d);
		return distance;
	} else {
        return 0;
    }
}

@end
