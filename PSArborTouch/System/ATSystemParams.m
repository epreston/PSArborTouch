//
//  ATSystemParams.m
//  PSArborTouch
//
//  Created by Ed Preston on 30/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATSystemParams.h"


@interface ATSystemParams ()
// Reserved
@end


@implementation ATSystemParams

- (instancetype) init
{
    self = [super init];
    if (self) {        
        _repulsion   = 1000;
        _stiffness   = 600;
        _friction    = 0.5;
        _deltaTime   = 0.02;
        _gravity     = YES;
        _precision   = 0.6;
        _timeout     = 1000 / 50;
    }
    return self;
}


#pragma mark - NSCopying

- (id) copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setRepulsion:_repulsion];
    [theCopy setStiffness:_stiffness];
    [theCopy setFriction:_friction];
    [theCopy setDeltaTime:_deltaTime];
    [theCopy setGravity:_gravity];
    [theCopy setPrecision:_precision];
    [theCopy setTimeout:_timeout];
    
    return theCopy;
}


#pragma mark - Keyed Archiving

- (void) encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeFloat:_repulsion forKey:@"repulsion"];
    [encoder encodeFloat:_stiffness forKey:@"stiffness"];
    [encoder encodeFloat:_friction forKey:@"friction"];
    [encoder encodeFloat:_deltaTime forKey:@"deltaTime"];
    [encoder encodeBool:_gravity forKey:@"gravity"];
    [encoder encodeFloat:_precision forKey:@"precision"];
    [encoder encodeFloat:_timeout forKey:@"timeout"];
}

- (instancetype) initWithCoder:(NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        _repulsion  = [decoder decodeFloatForKey:@"repulsion"];
        _stiffness  = [decoder decodeFloatForKey:@"stiffness"];
        _friction   = [decoder decodeFloatForKey:@"friction"];
        _deltaTime  = [decoder decodeFloatForKey:@"deltaTime"];
        _gravity    = [decoder decodeBoolForKey:@"gravity"];
        _precision  = [decoder decodeFloatForKey:@"precision"];
        _timeout    = [decoder decodeFloatForKey:@"timeout"];
    }
    return self;
}

@end
