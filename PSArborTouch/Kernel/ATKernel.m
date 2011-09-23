//
//  ATKernel.m
//  PSArborTouch
//
//  Created by Ed Preston on 22/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATKernel.h"
#import "ATPhysics.h"

// Interval in seconds: make sure this is more than 0
#define kTimerInterval 0.05


@implementation ATKernel

- (id)init
{
    self = [super init];
    if (self) {
        _timer      = nil;
        _queue      = dispatch_queue_create("com.prestonsoft.psarbortouch", 0);
        _paused     = NO;
        _running    = NO;
        _physics    = [[[ATPhysics alloc] initWithDeltaTime:0.02 
                                               stiffness:1000.0 
                                               repulsion:600.0 
                                                friction:0.5] retain];;
        
    }
    return self;
}


- (void) dealloc
{
    // tear down the timer
    BOOL timerInitialized = (_timer != nil);
    if ( timerInitialized ) {
        dispatch_source_cancel(_timer);
        dispatch_resume(_timer);  
        dispatch_release(_timer);
    }
    
    // stop the simulation
    [self stop];
    
    // release the queue
    dispatch_release(_queue);
    
    // release the physics object
    [_physics release];
    
    [super dealloc];
}


//    if (running_ == false) {
//        running_ = true;
//        dispatch_async(queue_, ^{
//            [self drawFrame];
//            running_ = false;
//        });
//    } else {
//        frame_drop_counter_++;
//        VerboseLog(@"Dropped a frame!");
//    }

- (dispatch_queue_t) physicsQueue
{
    return _queue;
}

- (CGFloat)fps
{
    return 0.0;
}


- (void) setFps:(CGFloat)fps
{
    // 
}


- (void) physicsUpdate
{
    // step physics
    
    // Run physics loop.  Stop timer if it returns NO on update.
    if ([_physics update] == NO) {
        [self stop];
    }
    
    
    
}


- (void) start:(BOOL)unpause
{
    
//    if (_tickInterval != nil) return;   // already running
//    if (_paused && !unpause) return;    // we've been .stopped before, wait for unpause
//    _paused = NO;
//    
//    // start the simulation
//    
//    
//    BOOL timerNotInitialized = !_timer;
//    if ( timerNotInitialized ) {
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        
//        // create our timer source
//        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//        
//        // set the time to fire
//        dispatch_source_set_timer(_timer,
//                                  dispatch_time(DISPATCH_TIME_NOW, kTimerInterval * NSEC_PER_SEC),
//                                  kTimerInterval * NSEC_PER_SEC, (kTimerInterval * NSEC_PER_SEC) / 2.0);
//        
//        // Hey, let's actually do something when the timer fires!
//        dispatch_source_set_event_handler(_timer, ^{
//            //            NSLog(@"WATCHDOG: task took longer than %f seconds",
//            //                  kTimerInterval);
//            
//            // Call back to main thread (UI Thread) to update the text
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self physicsUpdate];
//            });
//            
//            // ensure we never fire again
//            // dispatch_source_cancel(_timer);
//            
//            // pause the timer
//            // dispatch_suspend(_timer);
//        });
//    }
//    
//    if (_running == NO) {
//        _running = YES;
//        
//        // now that our timer is all set to go, start it
//        dispatch_resume(_timer);  
//    }
    
}

- (void) stop 
{
//    _paused = YES;
//    
//    // stop the simulation
//    
//    BOOL timerInitialized = (_timer != nil);
//    if ( timerInitialized && _running ) {
//        _running = NO;
//        dispatch_suspend(_timer);
//    }
}



@end
