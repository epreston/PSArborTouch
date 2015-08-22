//
//  ATEnergy.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATEnergy.h"


@interface ATEnergy ()
// reserved
@end


@implementation ATEnergy

- (instancetype) init
{
    self = [super init];
    if (self) {
        _sum    = 0.0;
        _max    = 0.0;
        _mean   = 0.0;
        _count  = 0;
    }
    return self;
}


#pragma mark - NSCopying

- (id) copyWithZone:(NSZone *)zone
{
    // use designated initializer
    id theCopy = [[[self class] allocWithZone:zone] init];
    
    [theCopy setSum:_sum];
    [theCopy setMax:_max];
    [theCopy setMean:_mean];
    [theCopy setCount:_count];
    
    return theCopy;
}


#pragma mark - Internal Interface


@end
