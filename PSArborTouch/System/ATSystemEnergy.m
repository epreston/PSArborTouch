//
//  ATSystemEnergy.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATSystemEnergy.h"

@implementation ATSystemEnergy

@synthesize sum = _sum;
@synthesize max = _max;
@synthesize mean = _mean;
@synthesize count = _count;

- (id) init
{
    self = [super init];
    if (self) {
        _sum    = 0.0;
        _max    = 0.0;
        _mean   = 0.0;
        _count  = 0.0;
    }
    return self;
}

@end
