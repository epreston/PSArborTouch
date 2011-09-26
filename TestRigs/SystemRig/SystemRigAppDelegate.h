//
//  SystemRigAppDelegate.h
//  SystemRig - System Test / Debug Rig
//
//  Created by Ed Preston on 26/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SystemRigViewController;

@interface SystemRigAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SystemRigViewController *viewController;

@end
