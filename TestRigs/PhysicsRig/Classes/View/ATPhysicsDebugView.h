//
//  ATPhysicsDebugView.h
//  PSArborTouch - Physics Test / Debug Rig
//
//  Created by Ed Preston on 21/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATPhysics;

@interface ATPhysicsDebugView : UIView

@property (nonatomic, strong) ATPhysics *physics;
@property (nonatomic, assign, getter=isDebugDrawing) BOOL debugDrawing;

@end
