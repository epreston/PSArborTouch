//
//  ATParticle.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATParticle.h"
#import "ATGeometry.h"


@interface ATParticle ()
// reserved
@end


@implementation ATParticle

- (instancetype) init
{
    self = [super init];
    if (self) {
        _velocity       = CGPointZero;
        _force          = CGPointZero;
        _tempMass       = 0.0;
        _connections    = 0;
    }
    return self;
}

- (instancetype) initWithVelocity:(CGPoint)velocity
                            force:(CGPoint)force
                         tempMass:(CGFloat)tempMass 
{
    self = [self init];
    if (self) {
        _velocity   = velocity;
        _force      = force;
        _tempMass   = tempMass;
    }
    return self;
}

- (void) applyForce:(CGPoint)force 
{
    self.force = CGPointAdd(self.force, CGPointDivideFloat(force, self.mass));
}


#pragma mark - Internal Interface


@end
