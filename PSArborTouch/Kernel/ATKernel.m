//
//  ATKernel.m
//  PSArborTouch
//
//  Created by Ed Preston on 22/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATKernel.h"
#import "ATPhysics.h"
#import "ATSpring.h"
#import "ATParticle.h"
#import "ATEnergy.h"

#import "ATSystemRenderer.h"


// Interval in seconds: make sure this is more than 0
#define kTimerInterval 0.05


@interface ATKernel ()

@property (nonatomic, readonly, assign) dispatch_queue_t physicsQueue;
@property (nonatomic, readonly, assign) dispatch_source_t physicsTimer;

@end


@implementation ATKernel

@synthesize physics = physics_;
@synthesize delegate = delegate_;

- (id)init
{
    self = [super init];
    if (self) {
        timer_      = nil;
        queue_      = nil;
        paused_     = NO;
        running_    = NO;
        physics_    = [[[ATPhysics alloc] initWithDeltaTime:0.02 
                                               stiffness:1000.0 
                                               repulsion:600.0 
                                                friction:0.5] retain];
        lastEnergy_ = [[[ATEnergy alloc] init] retain];
        lastBounds_ = CGRectMake(-1.0, -1.0, 2.0, 2.0);
    }
    return self;
}

- (void) dealloc
{
    delegate_ = nil;
    
    // stop the simulation
    [self stop];
    
    // tear down the timer
    BOOL timerInitialized = (timer_ != nil);
    if ( timerInitialized ) {
        dispatch_source_cancel(timer_);
        dispatch_resume(timer_);  
        dispatch_release(timer_);
    }
    
    // release the queue
    dispatch_release(queue_);
    
    // release the energy object
    [lastEnergy_ release];
    
    // release the physics object
    [physics_ release];
    
    [super dealloc];
}


#pragma mark - Rendering

- (BOOL) updateViewport
{
    return NO;
}


#pragma mark - Simulation Control

- (void) physicsUpdate
{
    // step physics
        
//    dispatch_async( [self physicsQueue] , ^{
        
        // Run physics loop.  
        BOOL stillActive = [physics_ update];
        
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
            
            ATEnergy *currentEnergy = physics_.energy;
            
            lastEnergy_.sum     = currentEnergy.sum;
            lastEnergy_.max     = currentEnergy.max;
            lastEnergy_.mean    = currentEnergy.mean;
            lastEnergy_.count   = currentEnergy.count;
            
            lastBounds_         = physics_.bounds;
            
            
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
    
    if (running_) return;               // already running
    if (paused_ && !unpause) return;    // we've been stopped before, wait for unpause
    paused_ = NO;
    
    // start the simulation
    
    if (running_ == NO) {
        running_ = YES;
        
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
    
    NSLog(@"Kernel started.");
}

- (void) stop 
{
    // stop the simulation
    
    paused_ = YES;
    
    BOOL timerInitialized = (timer_ != nil);
    if ( timerInitialized && running_ ) {
        running_ = NO;
        dispatch_suspend(timer_);
    }
    
    NSLog(@"Kernel stopped.");
}


#pragma mark - Cached Physics Properties

// We cache certain properties to provide information while the physics simulation 
// is running.

@synthesize simulationEnergy = lastEnergy_;
@synthesize simulationBounds = lastBounds_;


#pragma mark - Protected Physics Interface

// Physics methods protected by a GCD queue to ensure serial execution.  We do
// not what to do things like add and remove items from a simulation mid-calculation.

- (void) addParticle:(ATParticle *)particle
{
    dispatch_async( [self physicsQueue] , ^{
        
        [physics_ addParticle:particle];

        // start, unpaused NO
    });
}

- (void) removeParticle:(ATParticle *)particle
{
    dispatch_async( [self physicsQueue] , ^{
        
        [physics_ removeParticle:particle];
        
        // start, unpaused NO
    });
}

- (void) addSpring:(ATSpring *)spring
{
    dispatch_async( [self physicsQueue] , ^{
        
        [physics_ addSpring:spring];
        
        // start, unpaused NO
    });
}

- (void) removeSpring:(ATSpring *)spring
{
    dispatch_async( [self physicsQueue] , ^{
        
        [physics_ removeSpring:spring];
        
        // start, unpaused NO
    });
}


#pragma mark - Internal Interface

- (dispatch_queue_t) physicsQueue
{
    if (queue_ == nil) {
        queue_ = dispatch_queue_create("com.prestonsoft.psarbortouch", DISPATCH_QUEUE_SERIAL);
    }
    return queue_;
}

- (dispatch_source_t) physicsTimer
{
    BOOL timerNotInitialized = (timer_ == nil);
    if ( timerNotInitialized ) {
        
        //        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        // create our timer source
        //        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        timer_ = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, [self physicsQueue]);
        
        // set the time to fire
        dispatch_source_set_timer(timer_,
                                  dispatch_time(DISPATCH_TIME_NOW, kTimerInterval * NSEC_PER_SEC),
                                  kTimerInterval * NSEC_PER_SEC, (kTimerInterval * NSEC_PER_SEC) / 2.0);
    }
    
    return timer_;
}

@end
