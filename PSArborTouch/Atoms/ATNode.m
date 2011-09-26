//
//  ATNode.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATNode.h"

@implementation ATNode

@synthesize name = _name;
@synthesize mass = _mass;
@synthesize position = _position;
@synthesize fixed = _fixed;

- (id) init
{
    self = [super init];
    if (self) {
        _name = nil;
        _mass = 1.0;
        _position = CGPointZero;
        _fixed = NO;
    }
    return self;
}

- (id) initWithName:(NSString*)name mass:(CGFloat)mass position:(CGPoint)position fixed:(BOOL)fixed 
{
    self = [self init];
    if (self) {
        _name = [name copy];
        _mass = mass;
        _position = position;
        _fixed = fixed;
    }
    return self;
}

- (void) dealloc
{
    [_name release];
    
    [super dealloc];
}


@end
