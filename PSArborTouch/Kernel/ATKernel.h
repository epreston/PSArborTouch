//
//  ATKernel.h
//  PSArborTouch
//
//  Created by Ed Preston on 22/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <dispatch/dispatch.h>

@class ATPhysics;


@interface ATKernel : NSObject
{

@private
    dispatch_source_t   _timer;
    dispatch_queue_t    _queue;
    
    BOOL                _paused;
    BOOL                _running;
    
    ATPhysics          *_physics;
}

// Keep track of current fps, only work as hard as requested fps
// Manage all the GCD stuff for physics
// Queue requests
// Cache state of physics to respond to requests while its busy working


// ? Know when results are ready and call the render code ?

@property (nonatomic, readonly, assign) dispatch_queue_t physicsQueue;
@property (nonatomic, assign) CGFloat fps;

- (void) physicsUpdate;
- (void) start:(BOOL)unpause;
- (void) stop;

@end
