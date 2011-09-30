//
//  ATSystemParams.m
//  SystemRig
//
//  Created by Ed Preston on 30/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATSystemParams.h"


@interface ATSystemParams ()

@end


@implementation ATSystemParams

@synthesize repulsion   = repulsion_;
@synthesize stiffness   = stiffness_;
@synthesize friction    = friction_;
@synthesize deltaTime   = deltaTime_;
@synthesize gravity     = gravity_;
@synthesize precision   = precision_;
@synthesize timeout     = timeout_;

- (id)init
{
    self = [super init];
    if (self) {        
        repulsion_   = 1000;
        stiffness_   = 600;
        friction_    = 0.5;
        deltaTime_   = 0.02;
        gravity_     = YES;
        precision_   = 0.6;
        timeout_     = 1000 / 50;
    }
    
    return self;
}


#pragma mark - Keyed Archiving

- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeFloat:repulsion_ forKey:@"repulsion"];
    [encoder encodeFloat:stiffness_ forKey:@"stiffness"];
    [encoder encodeFloat:friction_ forKey:@"friction"];
    [encoder encodeFloat:deltaTime_ forKey:@"deltaTime"];
    [encoder encodeBool:gravity_ forKey:@"gravity"];
    [encoder encodeFloat:precision_ forKey:@"precision"];
    [encoder encodeFloat:timeout_ forKey:@"timeout"];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        repulsion_  = [decoder decodeFloatForKey:@"repulsion"];
        stiffness_  = [decoder decodeFloatForKey:@"stiffness"];
        friction_   = [decoder decodeFloatForKey:@"friction"];
        deltaTime_  = [decoder decodeFloatForKey:@"deltaTime"];
        gravity_    = [decoder decodeBoolForKey:@"gravity"];
        precision_  = [decoder decodeFloatForKey:@"precision"];
        timeout_    = [decoder decodeFloatForKey:@"timeout"];
    }
    return self;
}

@end
