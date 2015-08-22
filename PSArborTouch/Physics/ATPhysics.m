//
//  ATPhysics.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATPhysics.h"
#import "ATBarnesHutTree.h"
#import "ATSpring.h"
#import "ATParticle.h"
#import "ATGeometry.h"

#import "ATEnergy.h"


@interface ATPhysics ()
{
    
@private
    NSMutableArray  *_activeParticles;
    NSMutableArray  *_activeSprings;
    NSMutableArray  *_freeParticles;
    
    NSMutableArray  *_particles;
    NSMutableArray  *_springs;
}

- (void) tendParticles;
- (void) eulerIntegrator:(CGFloat)deltaTime;
- (void) applyBruteForceRepulsion;
- (void) applyBarnesHutRepulsion;
- (void) applySprings;
- (void) applyCenterDrift;
- (void) applyCenterGravity;
- (void) updateVelocity:(CGFloat)timestep;
- (void) updatePosition:(CGFloat)timestep;

@end


@implementation ATPhysics

- (instancetype) init
{
    self = [super init];
    if (self) {
        _activeParticles = [NSMutableArray arrayWithCapacity:32];
        _activeSprings  = [NSMutableArray arrayWithCapacity:32];
        _freeParticles  = [NSMutableArray arrayWithCapacity:32];
        _particles      = [NSMutableArray arrayWithCapacity:32];
        _springs        = [NSMutableArray arrayWithCapacity:32];
        _energy         = [[ATEnergy alloc] init];
        _bounds         = CGRectMake(-1.0, -1.0, 2.0, 2.0);
        _speedLimit     = 1000;
        _deltaTime      = 0.02;
        _stiffness      = 1000;
        _repulsion      = 600;
        _friction       = 0.3;
        _gravity        = NO;
        _theta          = 0.4;
        _bhTree         = [[ATBarnesHutTree alloc] init];
    }
    return self;
}

- (instancetype) initWithDeltaTime:(CGFloat)deltaTime
                         stiffness:(CGFloat)stiffness
                         repulsion:(CGFloat)repulsion
                          friction:(CGFloat)friction
{
    self = [self init];
    if (self) {
        _deltaTime  = deltaTime;
        _stiffness  = stiffness;
        _repulsion  = repulsion;
        _friction   = friction;
    }
    return self;
}



- (void) addParticle:(ATParticle *)particle
{
    NSParameterAssert(particle != nil);
    
    if (particle == nil) return;
    
    particle.connections = 0.0;
    [_activeParticles addObject:particle];
    [_freeParticles addObject:particle];
    [_particles addObject:particle];
}

- (void) removeParticle:(ATParticle *)particle
{
    NSParameterAssert(particle != nil);
    
    if (particle == nil) return;
    
    [_particles removeObjectIdenticalTo:particle];
    [_activeParticles removeObjectIdenticalTo:particle];
    [_freeParticles removeObjectIdenticalTo:particle];
}

- (void) addSpring:(ATSpring *)spring
{
    NSParameterAssert(spring != nil);
    
    if (spring == nil) return;
    
    [_activeSprings addObject:spring];
    [_springs addObject:spring];

    spring.point1.connections++;
    spring.point2.connections++;

    [_freeParticles removeObjectIdenticalTo:spring.point1];
    [_freeParticles removeObjectIdenticalTo:spring.point2];
}

- (void) removeSpring:(ATSpring *)spring
{
    NSParameterAssert(spring != nil);
    
    if (spring == nil) return;
    
    spring.point1.connections--;
    spring.point2.connections--;
    
    [_springs removeObjectIdenticalTo:spring];
    [_activeSprings removeObjectIdenticalTo:spring];
}


#pragma mark - Physics Stuff

- (BOOL) update; 
{
    [self tendParticles];
    [self eulerIntegrator:_deltaTime];
    
//    CGFloat motion = (self.energy.mean + self.energy.max) / 2; 
    CGFloat motion = (self.energy.max - self.energy.mean) / 2;
    
    if (motion < 0.05) { // 0.05
//        NSLog(@"We would stop now.");
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - Internal Interface

- (void) tendParticles 
{
    // Barnes-Hut requires accurate bounds.  If a particle has been modified from one
    // run to the next, detect it here to ensure the bounds are correct.
    
    CGPoint bottomright = CGPointZero;
    CGPoint topleft     = CGPointZero;
    BOOL firstParticle  = YES;
    
    for (ATParticle *particle in _activeParticles) {
        
        // decay down any of the temporary mass increases that were passed along
        // by using an {_m:} instead of an {m:} (which is to say via a Node having
        // its .tempMass attr set)
        
        if (particle.tempMass != 0.0) {
            if (ABS(particle.mass - particle.tempMass) < 1.0) {
                particle.mass = particle.tempMass;
                particle.tempMass = 0.0;
            } else {
                particle.mass *= 0.98;
            }
        }
        
        // zero out the velocity from one tick to the next
        particle.velocity = CGPointZero;
        
        // update the bounds
        CGPoint pt = particle.position;
        
        if (firstParticle) {
            bottomright     = pt;
            topleft         = pt;
            firstParticle   = NO;
        }
        
        if (pt.x > bottomright.x) bottomright.x = pt.x;
        if (pt.y > bottomright.y) bottomright.y = pt.y;          
        if   (pt.x < topleft.x)   topleft.x = pt.x;
        if   (pt.y < topleft.y)   topleft.y = pt.y;
    }
    
    self.bounds = CGRectMake(topleft.x, topleft.y, bottomright.x - topleft.x, bottomright.y - topleft.y);
}

- (void) eulerIntegrator:(CGFloat)deltaTime 
{
    NSParameterAssert(deltaTime > 0.0);
    
    // Without advancement of time, does the simulation have meaning?
    if (deltaTime <= 0.0) return;
    
    if (self.repulsion > 0.0) {
        
        if (self.theta > 0.0) {
            [self applyBarnesHutRepulsion];
        } else {
            [self applyBruteForceRepulsion];
        }
        
    }
    
    if (self.stiffness > 0.0) [self applySprings];
    [self applyCenterDrift];
    if (self.gravity) [self applyCenterGravity];
    [self updateVelocity:deltaTime];
    [self updatePosition:deltaTime];
}

- (void) applyBruteForceRepulsion 
{
    for (ATParticle *subject in _activeParticles) {
        for (ATParticle *object in _activeParticles) {
            if (subject != object){
                CGPoint d = CGPointSubtract(subject.position, object.position);
                CGFloat distance = MAX( 1.0, CGPointMagnitude(d) );
                CGPoint direction = (CGPointMagnitude(d) > 0.0) ? d : CGPointNormalize( CGPointRandom(1.0) );
                
                // apply force to each end point
                // (consult the cached `real' mass value if the mass is being poked to allow
                // for repositioning. the poked mass will still be used in .applyforce() so
                // all should be well)
                
                CGPoint force = CGPointDivideFloat( 
                                                   CGPointScale(direction, 
                                                                (self.repulsion * object.mass * 0.5) ), 
                                                   (distance * distance * 0.5) );
                
                [subject applyForce:force];
                
                
                force = CGPointDivideFloat(
                                           CGPointScale(direction, 
                                                        (self.repulsion * subject.mass * 0.5) ),
                                           (distance * distance * -0.5) );
                
                [object applyForce:force];
            }
        }
    }
}

- (void) applyBarnesHutRepulsion 
{
    // build a barnes-hut tree...
    [_bhTree updateWithBounds:self.bounds theta:self.theta];
    
    for (ATParticle *particle in _activeParticles) {
        [_bhTree insertParticle:particle];
    }
    
    // ...and use it to approximate the repulsion forces
    for (ATParticle *particle in _activeParticles) {
        [_bhTree applyForces:particle andRepulsion:self.repulsion];
    }
}

- (void) applySprings 
{
    for (ATSpring *spring in _activeSprings) {
        CGPoint d = CGPointSubtract(spring.target.position, spring.source.position); // the direction of the spring
        
        CGFloat displacement = spring.length - CGPointMagnitude(d);
        
        CGPoint direction = CGPointNormalize( (CGPointMagnitude(d) > 0.0) ? d : CGPointRandom(1.0) );
        
        // BUG:
        // since things oscillate wildly for hub nodes, should probably normalize spring
        // forces by the number of incoming edges for each node. naive normalization 
        // doesn't work very well though. what's the `right' way to do it?
        
        // apply force to each end point
        [spring.point1 applyForce:CGPointScale(direction, spring.stiffness * displacement * -0.5) ];
        [spring.point2 applyForce:CGPointScale(direction, spring.stiffness * displacement * 0.5) ];
    }    
}

- (void) applyCenterDrift 
{
    // find the centroid of all the particles in the system and shift everything
    // so the cloud is centered over the origin
    
    NSUInteger numParticles = 0;
    CGPoint centroid = CGPointZero;
    for (ATParticle *particle in _activeParticles) {
        centroid = CGPointAdd(centroid, particle.position);
        numParticles++;
    }
    
    if (numParticles == 0) return;
    
    CGPoint correction = CGPointDivideFloat(centroid, -numParticles);
    for (ATParticle *particle in _activeParticles) {
        [particle applyForce:correction];
    }
}

- (void) applyCenterGravity 
{
    // attract each node to the origin
    for (ATParticle *particle in _activeParticles) {
        CGPoint direction = CGPointScale(particle.position, -1.0);
        [particle applyForce:CGPointScale(direction, (self.repulsion / 100.0))];
    }
}

- (void) updateVelocity:(CGFloat)timestep 
{
    NSParameterAssert(timestep > 0.0);
    
    // Without advancement of time, does the simulation have meaning?
    if (timestep <= 0.0) return;
    
    // translate forces to a new velocity for this particle
    for (ATParticle *particle in _activeParticles) {
        if (particle.fixed){
            particle.velocity = CGPointZero;
            particle.force = CGPointZero;
            continue;
        }
        
        particle.velocity = CGPointScale(CGPointAdd(particle.velocity, 
                                                    CGPointScale( particle.force, timestep)), 
                                         (1.0 - self.friction));
        
        particle.force = CGPointZero;
        
        // Slow down the particle if it is moving too fast.  Due to large timeStep etc.
        CGFloat speed = CGPointMagnitude(particle.velocity);
        if (speed > self.speedLimit) {
            particle.velocity = CGPointDivideFloat(particle.velocity, speed * speed);   
        }
    }
}

- (void) updatePosition:(CGFloat)timestep 
{
    NSParameterAssert(timestep > 0.0);
    
    // Without advancement of time, does the simulation have meaning?
    if (timestep <= 0.0) return;
    
    // translate velocity to a position delta
    CGFloat sum = 0.0, max = 0.0, n = 0.0;
    CGPoint bottomright = CGPointZero;
    CGPoint topleft     = CGPointZero;
    BOOL firstParticle  = YES;
    
    for (ATParticle *particle in _activeParticles) {
        // move the node to its new position
        particle.position = CGPointAdd(particle.position, CGPointScale(particle.velocity, timestep) );
        
        // keep stats to report in systemEnergy
        CGFloat speed = CGPointMagnitude(particle.velocity);
        CGFloat e = speed * speed;
        sum += e;
        max = MAX(e, max);
        n++;
        
        // update the bounds
        CGPoint pt = particle.position;
        
        if (firstParticle) {
            bottomright     = pt;
            topleft         = pt;
            firstParticle   = NO;
        }
        
        if (pt.x > bottomright.x) bottomright.x = pt.x;
        if (pt.y > bottomright.y) bottomright.y = pt.y;          
        if   (pt.x < topleft.x)   topleft.x = pt.x;
        if   (pt.y < topleft.y)   topleft.y = pt.y;
    }
    
    _energy.sum     = sum;
    _energy.max     = max;
    _energy.mean    = sum/n;
    _energy.count   = n;
    
    self.bounds = CGRectMake(topleft.x, topleft.y, bottomright.x - topleft.x, bottomright.y - topleft.y);
}


@end
