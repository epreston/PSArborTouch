//
//  ATEdge.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATEdge.h"
#import "ATNode.h"

@implementation ATEdge

@synthesize source = _source;
@synthesize target = _target;
@synthesize length = _length;

- (id) init
{
    self = [super init];
    if (self) {
        _source = nil;
        _target = nil;
        _length = 1.0;
    }
    return self;
}

- (id) initWithSource:(ATNode*)source target:(ATNode*)target length:(CGFloat)length 
{
    self = [self init];
    if (self) {
        _source = [source retain];
        _target = [target retain];
        _length = length;
    }
    return self;
}

- (void) dealloc
{
    [_source release];
    [_target release];
    
    [super dealloc];
}


@end
