//
//  ATSpring.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATSpring.h"
#import "ATParticle.h"
#import "ATGeometry.h"

@implementation ATSpring

@synthesize point1 = _point1;
@synthesize point2 = _point2;
@synthesize length = _length;
@synthesize stiffness = _stiffness;

- (id) init
{
    self = [super init];
    if (self) {
        _point1 = nil;
        _point2 = nil;
        _length = 1.0;
        _stiffness = 0.0;
    }
    return self;
}


- (id) initWithPoint1:(ATParticle*)point1 
               point2:(ATParticle*)point2 
               length:(CGFloat)length 
            stiffness:(CGFloat)stiffness 
{
    self = [self init];
    if (self) {
        _point1 = [point1 retain];
        _point2 = [point2 retain];
        _length = length;
        _stiffness = stiffness;
    }
    return self;
}


- (void)dealloc
{
    [_point1 release];
    [_point2 release];
    
    [super dealloc];
}


- (CGFloat) distanceToParticle:(ATParticle *)particle 
{
    // see http://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment/865080#865080
    CGPoint n = CGPointNormalize( CGPointNormal( CGPointSubtract(self.point2.position, self.point1.position) ) );
    CGPoint ac = CGPointSubtract(particle.position, self.point1.position);
    return ABS(ac.x * n.x + ac.y * n.y);
}


@end
