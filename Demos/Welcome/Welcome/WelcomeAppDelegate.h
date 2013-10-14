//
//  WelcomeAppDelegate.h
//  Welcome - PSArborTouch Example
//
//  Created by Ed Preston on 3/10/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WelcomeViewController;

@interface WelcomeAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet WelcomeViewController *viewController;

@end
