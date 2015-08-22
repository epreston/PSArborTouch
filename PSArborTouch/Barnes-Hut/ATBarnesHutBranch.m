//
//  ATBarnesHutBranch.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATBarnesHutBranch.h"


@interface ATBarnesHutBranch ()
// reserved
@end


@implementation ATBarnesHutBranch

- (instancetype) init
{
    self = [super init];
    if (self) {
        _bounds     = CGRectZero;
        _mass       = 0.0;
        _position   = CGPointZero;
        
        _ne = nil;
        _nw = nil;
        _se = nil;
        _sw = nil;
    }
    return self;
}

- (instancetype) initWithBounds:(CGRect)bounds mass:(CGFloat)mass position:(CGPoint)position
{
    self = [self init];
    if (self) {
        _bounds     = bounds;
        _mass       = mass;
        _position   = position;
    }
    return self;
}


#pragma mark - Internal Interface


@end
