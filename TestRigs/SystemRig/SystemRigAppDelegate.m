//
//  SystemRigAppDelegate.m
//  SystemRig - System Test / Debug Rig
//
//  Created by Ed Preston on 26/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "SystemRigAppDelegate.h"
#import "SystemRigViewController.h"

@implementation SystemRigAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
