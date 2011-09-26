//
//  ATBarnesHutBranch.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATBarnesHutBranch.h"

@implementation ATBarnesHutBranch

@synthesize bounds = _bounds;
@synthesize mass = _mass;
@synthesize position = _position;
@synthesize ne = _ne;
@synthesize nw = _nw;
@synthesize se = _se;
@synthesize sw = _sw;

- (id) init
{
    self = [super init];
    if (self) {
        _bounds = CGRectZero;
        _mass = 0.0;
        _position = CGPointZero;
        _ne = nil;
        _nw = nil;
        _se = nil;
        _sw = nil;
    }
    return self;
}


- (id) initWithBounds:(CGRect)bounds mass:(CGFloat)mass position:(CGPoint)position 
{
    self = [self init];
    if (self) {
        _bounds = bounds;
        _mass = mass;
        _position = position;
    }
    return self;
}



- (void) dealloc
{
    [_ne release];
    [_nw release];
    [_se release];
    [_sw release];
    
    [super dealloc];
}



@end
