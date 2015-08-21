//
//  KernelRigViewController.h
//  KernelRig - Kernel Test / Debug Rig
//
//  Created by Ed Preston on 22/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATSystemRenderer.h"

@class ATKernelDebugView;

@interface KernelRigViewController : UIViewController <ATDebugRendering>

@property (nonatomic, strong) IBOutlet ATKernelDebugView *debugView;

@end
