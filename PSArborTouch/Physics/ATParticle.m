//
//  ATParticle.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATParticle.h"
#import "ATGeometry.h"


@interface ATParticle ()
// reserved
@end


@implementation ATParticle

@synthesize velocity    = velocity_;
@synthesize force       = force_;
@synthesize tempMass    = tempMass_;
@synthesize connections = connections_;

- (id) init
{
    self = [super init];
    if (self) {
        velocity_       = CGPointZero;
        force_          = CGPointZero;
        tempMass_       = 0.0;
        connections_    = 0;
    }
    return self;
}

- (id) initWithVelocity:(CGPoint)velocity 
                  force:(CGPoint)force 
               tempMass:(CGFloat)tempMass 
{
    self = [self init];
    if (self) {
        velocity_   = velocity;
        force_      = force;
        tempMass_   = tempMass;
    }
    return self;
}

- (void) applyForce:(CGPoint)force 
{
    self.force = CGPointAdd(self.force, CGPointDivideFloat(force, self.mass));
}


#pragma mark - Internal Interface


@end
