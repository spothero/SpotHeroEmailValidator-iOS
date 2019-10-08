//
//  AppDelegate.m
//  SpotHeroEmailValidatorDemo
//
//  Created by Brian Drelling on 10/7/19.
//  Copyright © 2019 SpotHero, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame: UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[DemoViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
