//
//  ATKernel.m
//  PSArborTouch
//
//  Created by Ed Preston on 22/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATKernel.h"
#import "ATPhysics.h"
#import "ATSpring.h"
#import "ATParticle.h"
#import "ATEnergy.h"

#import "ATSystemParams.h"
#import "ATSystemRenderer.h"

#import <dispatch/dispatch.h>

// Interval in seconds: make sure this is more than 0
#define kTimerInterval 0.05


@interface ATKernel ()
{
    
@private
    dispatch_source_t   _timer;
    dispatch_queue_t    _queue;
    
    BOOL                _paused;
    BOOL                _running;
    
    id                  __unsafe_unretained _delegate;      // UPDATE THIS ! = id <protocol> delegate_;
}

@property (nonatomic, readonly) dispatch_queue_t physicsQueue;
@property (nonatomic, readonly) dispatch_source_t physicsTimer;

@end


@implementation ATKernel

@synthesize delegate = _delegate;

- (instancetype) init
{
    self = [super init];
    if (self) {
        _timer      = nil;
        _queue      = nil;
        _paused     = NO;
        _running    = NO;
        _physics    = [[ATPhysics alloc] initWithDeltaTime:0.02 
                                               stiffness:1000.0 
                                               repulsion:600.0 
                                                friction:0.5];
        _simulationEnergy = [[ATEnergy alloc] init];
        _simulationBounds = CGRectMake(-1.0, -1.0, 2.0, 2.0);
    }
    return self;
}

- (void) dealloc
{
    _delegate = nil;
    
    // stop the simulation
    [self stop];
    
    // tear down the timer
    BOOL timerInitialized = (_timer != nil);
    if ( timerInitialized ) {
        dispatch_source_cancel(_timer);
        dispatch_resume(_timer);  
    }
}


#pragma mark - Rendering (override in subclass)

- (BOOL) updateViewport
{
    return NO;
}


#pragma mark - Simulation Control

- (void) stepSimulation
{
    // step physics
        
//    dispatch_async( [self physicsQueue] , ^{
        
        // Run physics loop.  
        BOOL stillActive = [_physics update];
        
        // Update the viewport
        if ([self updateViewport]) {
            stillActive = YES;
        }
        
        // Stop timer if not stillActive.
        if (!stillActive) {
            [self stop];
            
        }
        
        // Call back to main thread (UI Thread) to update the text
        // Dispatch SYNC or ASYNC here?  Could we queue too many updates?
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Update cached properties
            //
            //      - Energy in the simulation
            //      - Bounds of the simulation
            
            ATEnergy *currentEnergy = _physics.energy;
            
            _simulationEnergy.sum     = currentEnergy.sum;
            _simulationEnergy.max     = currentEnergy.max;
            _simulationEnergy.mean    = currentEnergy.mean;
            _simulationEnergy.count   = currentEnergy.count;
            
            _simulationBounds         = _physics.bounds;
            
            
            // Call back into the main thread
            //
            //      - Update the debug barnes-hut display
            //      - Update the debug bounds display
            //      - Update the debug viewport display
            //      - Update the edge display
            //      - Update the node display
            
            if ( self.delegate ) {
                if ( self.delegate && [self.delegate conformsToProtocol:@protocol(ATDebugRendering) ]) {
                    [(NSObject<ATDebugRendering> *)self.delegate redraw];
                }
            }
        });
//    });
}

- (void) start:(BOOL)unpause
{
    if (_running) return;               // already running
    if (_paused && !unpause) return;    // we've been stopped before, wait for unpause
    _paused = NO;
    
    // start the simulation
    
    if (_running == NO) {
        _running = YES;
        
        // Configure handler when it fires
        dispatch_source_set_event_handler( [self physicsTimer], ^{
            
            // Call back to main thread (UI Thread) to update the text
            //            dispatch_async(dispatch_get_main_queue(), ^{
            [self stepSimulation];
            //            });
            
        });
        
        // Start the timer
        dispatch_resume( [self physicsTimer] );  
    }
    
    NSLog(@"Kernel started.");
}

- (void) stop 
{
    // stop the simulation
    
    _paused = YES;
    
    BOOL timerInitialized = (_timer != nil);
    if ( timerInitialized && _running ) {
        _running = NO;
        dispatch_suspend(_timer);
    }
    
    NSLog(@"Kernel stopped.");
}


#pragma mark - Protected Physics Interface

// Physics methods protected by a GCD queue to ensure serial execution.  We do
// not want to do things like add and remove items from a simulation mid-calculation.

- (void) updateSimulation:(ATSystemParams *)params
{
    NSParameterAssert(params != nil);
    if (params == nil) return;
    
    dispatch_async( [self physicsQueue] , ^{
        
        _physics.repulsion  = params.repulsion;
        _physics.stiffness  = params.stiffness;
        _physics.friction   = params.friction;
        _physics.deltaTime  = params.deltaTime;
        _physics.gravity    = params.gravity;
        _physics.theta      = params.precision;
        
        // params.timeout;  // Used by kernel to control update cycle
        
        // start, unpaused NO
    });
}

- (void) addParticle:(ATParticle *)particle
{
    NSParameterAssert(particle != nil);
    if (particle == nil) return;
    
    dispatch_async( [self physicsQueue] , ^{
        
        [_physics addParticle:particle];

        // start, unpaused NO
    });
}

- (void) removeParticle:(ATParticle *)particle
{
    NSParameterAssert(particle != nil);
    if (particle == nil) return;
    
    dispatch_async( [self physicsQueue] , ^{
        
        [_physics removeParticle:particle];
        
        // start, unpaused NO
    });
}

- (void) addSpring:(ATSpring *)spring
{
    NSParameterAssert(spring != nil);
    if (spring == nil) return;
    
    dispatch_async( [self physicsQueue] , ^{
        
        [_physics addSpring:spring];
        
        // start, unpaused NO
    });
}

- (void) removeSpring:(ATSpring *)spring
{
    NSParameterAssert(spring != nil);
    if (spring == nil) return;
    
    dispatch_async( [self physicsQueue] , ^{
        
        [_physics removeSpring:spring];
        
        // start, unpaused NO
    });
}


#pragma mark - Internal Interface

- (dispatch_queue_t) physicsQueue
{
    if (_queue == nil) {
        _queue = dispatch_queue_create("com.prestonsoft.psarbortouch", DISPATCH_QUEUE_SERIAL);
    }
    return _queue;
}

- (dispatch_source_t) physicsTimer
{
    BOOL timerNotInitialized = (_timer == nil);
    if ( timerNotInitialized ) {
        
        //        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        // create our timer source
        //        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, [self physicsQueue]);
        
        // set the time to fire
        dispatch_source_set_timer(_timer,
                                  dispatch_time(DISPATCH_TIME_NOW, kTimerInterval * NSEC_PER_SEC),
                                  kTimerInterval * NSEC_PER_SEC, (kTimerInterval * NSEC_PER_SEC) / 2.0);
    }
    
    return _timer;
}

@end
