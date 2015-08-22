//
//  ATKernel.h
//  PSArborTouch
//
//  Created by Ed Preston on 22/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATPhysics;
@class ATParticle;
@class ATSpring;
@class ATEnergy;

@class ATSystemParams;

@interface ATKernel : NSObject


#pragma mark - Rendering

@property (nonatomic, unsafe_unretained) id delegate;
- (BOOL) updateViewport;

#pragma mark - Simulation Control

- (void) stepSimulation;
- (void) start:(BOOL)unpause;
- (void) stop;

#pragma mark - Debug Physics Properties

@property (nonatomic, readonly, strong) ATPhysics *physics;

#pragma mark - Cached Physics Properties
// We cache certain properties to provide information while the physics
// simulation is running.

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
