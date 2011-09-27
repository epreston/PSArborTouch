//
//  ATKernel.m
//  PSArborTouch
//
//  Created by Ed Preston on 22/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATKernel.h"
#import "ATPhysics.h"
#import "ATParticle.h" // ??
#import "ATSpring.h"

#import "ATSystemEnergy.h"


// Interval in seconds: make sure this is more than 0
#define kTimerInterval 0.05


@interface ATKernel ()
// Private interface for ATKernel

@property (nonatomic, readonly, assign) dispatch_queue_t physicsQueue;
@property (nonatomic, readonly, assign) dispatch_source_t physicsTimer;

@end


@implementation ATKernel


- (id)init
{
    self = [super init];
    if (self) {
        _timer      = nil;
        _queue      = nil;
        _paused     = NO;
        _running    = NO;
        _physics    = [[[ATPhysics alloc] initWithDeltaTime:0.02 
                                               stiffness:1000.0 
                                               repulsion:600.0 
                                                friction:0.5] retain];
        _lastEnergy = [[[ATSystemEnergy alloc] init] retain];
    }
    return self;
}


- (void) dealloc
{
    // stop the simulation
    [self stop];
    
    // tear down the timer
    BOOL timerInitialized = (_timer != nil);
    if ( timerInitialized ) {
        dispatch_source_cancel(_timer);
        dispatch_resume(_timer);  
        dispatch_release(_timer);
    }
    
    // release the queue
    dispatch_release(_queue);
    
    // release the energy object
    [_lastEnergy release];
    
    // release the physics object
    [_physics release];
    
    [super dealloc];
}


#pragma mark - Simulation Control

- (void) physicsUpdate
{
    // step physics
        
    dispatch_async( [self physicsQueue] , ^{
        
        // Run physics loop.  Stop timer if it returns NO on update.
        if ([_physics update] == NO) {
            [self stop];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Update cached properties
            //
            //      - Energy in the simulation
            //      - Bounds of the simulation
            
            ATSystemEnergy *currentEnergy = _physics.energy;
            
            _lastEnergy.sum     = currentEnergy.sum;
            _lastEnergy.max     = currentEnergy.max;
            _lastEnergy.mean    = currentEnergy.mean;
            _lastEnergy.count   = currentEnergy.count;
            
        });
        
        // Call back to main thread (UI Thread) to update the text
        // Dispatch SYNC or ASYNC here?  Could we queue too many updates?
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Call back into the main thread
            //
            //      - Update the debug barnes-hut display
            //      - Update the debug bounds display
            //      - Update the debug viewport display
            //      - Update the edge display
            //      - Update the node display
            
        });
        
    });
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
            [self physicsUpdate];
            //            });
            
        });
        
        // Start the timer
        dispatch_resume( [self physicsTimer] );  
    }
    
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


#pragma mark - Cached Physics Properties

// We cache certain properties to provide information while the physics simulation 
// is running.

@synthesize energy = _lastEnergy;


#pragma mark - Protected Physics Interface

// Physics methods protected by a GCD queue to ensure serial execution.  We do
// not what to do things like add and remove items from a simulation mid-calculation.

- (void) addParticle:(ATParticle *)particle
{
    dispatch_async( [self physicsQueue] , ^{
        
        [_physics addParticle:particle];

        // start, unpaused NO
    });
}

- (void) removeParticle:(ATParticle *)particle
{
    dispatch_async( [self physicsQueue] , ^{
        
        [_physics removeParticle:particle];
        
        // start, unpaused NO
    });
}

- (void) addSpring:(ATSpring *)spring
{
    dispatch_async( [self physicsQueue] , ^{
        
        [_physics addSpring:spring];
        
        // start, unpaused NO
    });
}

- (void) removeSpring:(ATSpring *)spring
{
    dispatch_async( [self physicsQueue] , ^{
        
        [_physics removeSpring:spring];
        
        // start, unpaused NO
    });
}


@end
