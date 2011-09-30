//
//  KernelRigViewController.h
//  KernelRig - Kernel Test / Debug Rig
//
//  Created by Ed Preston on 22/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "ATSystemRenderer.h"

@class ATKernel;
@class ATKernelDebugView;

@interface KernelRigViewController : UIViewController <ATDebugRendering>
{
    
@private
    ATKernel        *_kernel;
    
    NSMutableArray  *_nodes;
    ATKernelDebugView *_debugView;
}

@property (nonatomic, retain) IBOutlet ATKernelDebugView *debugView;

@end
