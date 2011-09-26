//
//  ATPhysics.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ATBarnesHutTree;
@class ATSystemEnergy;
@class ATParticle;
@class ATSpring;

@interface ATPhysics : NSObject
{
    
@private
    
    ATBarnesHutTree *_bhTree;
    NSMutableArray  *_activeParticles;
    NSMutableArray  *_activeSprings;
    NSMutableArray  *_freeParticles;
    
    NSMutableArray  *_particles;
    NSMutableArray  *_springs;
    
    CGFloat          _epoch;
    ATSystemEnergy  *_energy;
    CGRect           _bounds;
    
    CGFloat     _speedLimit;
    
    CGFloat     _deltaTime;
    CGFloat     _stiffness;
    CGFloat     _repulsion;
    CGFloat     _friction;
    
    BOOL        _gravity;
    CGFloat     _theta;
}

@property (nonatomic, retain) ATBarnesHutTree *bhTree;

@property (nonatomic, retain) NSMutableArray *particles;
- (void) addParticle:(ATParticle *)particle;
- (void) removeParticle:(ATParticle *)particle;

@property (nonatomic, retain) NSMutableArray *springs;
- (void) addSpring:(ATSpring *)spring;
- (void) removeSpring:(ATSpring *)spring;

@property (nonatomic, assign) CGFloat epoch;
@property (nonatomic, readonly, copy) ATSystemEnergy *energy;
@property (nonatomic, assign) CGRect bounds;

@property (nonatomic, assign) CGFloat speedLimit;

@property (nonatomic, assign) CGFloat deltaTime;
@property (nonatomic, assign) CGFloat stiffness;
@property (nonatomic, assign) CGFloat repulsion;
@property (nonatomic, assign) CGFloat friction;

@property (nonatomic, assign) BOOL gravity;
@property (nonatomic, assign) CGFloat theta;


- (id)init;

- (id)initWithDeltaTime:(CGFloat)deltaTime 
              stiffness:(CGFloat)stiffness 
              repulsion:(CGFloat)repulsion 
               friction:(CGFloat)friction;


- (BOOL) update;


@end
