//
//  KernelRigAppDelegate.h
//  KernelRig - Kernel Test / Debug Rig
//
//  Created by Ed Preston on 22/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KernelRigViewController;

@interface KernelRigAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet KernelRigViewController *viewController;

@end
