//
//  SystemRigAppDelegate.m
//  SystemRig - System Test / Debug Rig
//
//  Created by Ed Preston on 26/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "SystemRigAppDelegate.h"
#import "SystemRigViewController.h"


@implementation SystemRigAppDelegate


#pragma mark - Application Lifecycle

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [_window setRootViewController:_viewController];
    [_window addSubview:_viewController.view];
    [_window makeKeyAndVisible];
    
    return YES;
}


@end
