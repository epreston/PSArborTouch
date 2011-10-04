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
@class ATParticle;
@class ATSpring;
@class ATEnergy;

@class ATSystemParams;

@interface ATKernel : NSObject
{

@private
    dispatch_source_t   timer_;
    dispatch_queue_t    queue_;
    
    BOOL                paused_;
    BOOL                running_;
    
    ATPhysics          *physics_;
    
    ATEnergy           *lastEnergy_;
    CGRect              lastBounds_;
    
    id                  delegate_;      // UPDATE THIS ! = id <protocol> delegate_;
}

#pragma mark - Rendering

@property (nonatomic, assign) id delegate;
- (BOOL) updateViewport;

#pragma mark - Simulation Control

- (void) stepSimulation;
- (void) start:(BOOL)unpause;
- (void) stop;

#pragma mark - Debug Physics Properties

@property (nonatomic, readonly, retain) ATPhysics *physics;

#pragma mark - Cached Physics Properties

@property (nonatomic, readonly, copy) ATEnergy *simulationEnergy;
@property (nonatomic, readonly, assign) CGRect simulationBounds;

#pragma mark - Protected Physics Interface

// Physics methods protected by a GCD queue to ensure serial execution.
// TODO: Move into protocol / interface definition

- (void) updateSimulation:(ATSystemParams *)params;

- (void) addParticle:(ATParticle *)particle;
- (void) removeParticle:(ATParticle *)particle;

- (void) addSpring:(ATSpring *)spring;
- (void) removeSpring:(ATSpring *)spring;


@end
