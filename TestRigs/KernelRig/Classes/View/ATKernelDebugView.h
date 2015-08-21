//
//  ATKernelDebugView.h
//  PSArborTouch - Kernel Test / Debug Rig
//
//  Created by Ed Preston on 29/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATPhysics;

@interface ATKernelDebugView : UIView

@property (nonatomic, strong) ATPhysics *physics;
@property (nonatomic, assign, getter=isDebugDrawing) BOOL debugDrawing;

@end
