//
//  ATPhysicsDebugView.h
//  PSArborTouch
//
//  Created by Ed Preston on 21/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATPhysics;

@interface ATPhysicsDebugView : UIView
{

@private
    
    ATPhysics *_physics;
    BOOL _debugDrawing;
}

@property (nonatomic, retain) ATPhysics *physics;
@property (nonatomic, assign, getter=isDebugDrawing) BOOL debugDrawing;

@end
