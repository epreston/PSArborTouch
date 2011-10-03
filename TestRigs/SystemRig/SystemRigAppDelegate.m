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

@synthesize window = window_;
@synthesize viewController = viewController_;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) dealloc
{
    [window_ release];
    [viewController_ release];
    [super dealloc];
}

@end
