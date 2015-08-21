//
//  PSArborTouchAppDelegate.h
//  PSArborTouch - Physics Test / Debug Rig
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//


#import <UIKit/UIKit.h>


@class PSArborTouchViewController;

@interface PhysicsRigAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet PSArborTouchViewController *viewController;

@end
