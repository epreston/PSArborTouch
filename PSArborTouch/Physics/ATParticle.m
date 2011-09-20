//
//  ATParticle.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATParticle.h"
#import "ATGeometry.h"

@implementation ATParticle

@synthesize velocity    = _velocity;
@synthesize force       = _force;
@synthesize tempMass    = _tempMass;
@synthesize connections = _connections;

- (id)init
{
    self = [super init];
    if (self) {
        _velocity       = CGPointZero;
        _force          = CGPointZero;
        _tempMass       = 0.0;
        _connections    = 0.0;
    }
    return self;
}


- (id)initWithVelocity:(CGPoint)velocity force:(CGPoint)force tempMass:(CGFloat)tempMass 
{
    self = [self init];
    if (self) {
        _velocity   = velocity;
        _force      = force;
        _tempMass   = tempMass;
    }
    return self;
}


- (void)dealloc
{
    
    [super dealloc];
}



- (void) applyForce:(CGPoint)force 
{
    self.force = CGPointAdd(self.force, CGPointDivideFloat(force, self.mass));
}

@end
