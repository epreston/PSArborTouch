//
//  ATEdge.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATEdge.h"
#import "ATNode.h"

#import "ATGeometry.h"

// Edges have negative indexes, Nodes have positive indexes,
static NSInteger nextEdgeIndex_ = -1;


@interface ATEdge ()
// Reserved
@end


@implementation ATEdge

@synthesize index       = index_;
@synthesize source      = source_;
@synthesize target      = target_;
@synthesize length      = length_;
@synthesize userData    = data_;

- (id) init
{
    self = [super init];
    if (self) {
        index_     = [@(nextEdgeIndex_--) retain];
        source_ = nil;
        target_ = nil;
        length_ = 1.0;
        data_   = nil;
    }
    return self;
}

- (id) initWithSource:(ATNode *)source target:(ATNode *)target length:(CGFloat)length 
{
    self = [self init];
    if (self) {
        source_ = [source retain];
        target_ = [target retain];
        length_ = length;
    }
    return self;
}

- (id) initWithSource:(ATNode *)source target:(ATNode *)target userData:(NSMutableDictionary *)data 
{
    self = [self init];
    if (self) {
        source_ = [source retain];
        target_ = [target retain];
        data_   = [data retain];
    }
    return self;
}

- (void) dealloc
{
    [data_ release];
    
    [source_ release];
    [target_ release];
    
    [index_ release];
    
    [super dealloc];
}


#pragma mark - Geometry

- (CGFloat) distanceToNode:(ATNode *)node
{
    NSParameterAssert(node != nil);
    
// see http://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment/865080#865080
    CGPoint n = CGPointNormalize( CGPointNormal( CGPointSubtract(self.target.position, self.source.position) ) );
    CGPoint ac = CGPointSubtract(node.position, self.source.position);
    return ABS(ac.x * n.x + ac.y * n.y);
}


#pragma mark - Internal Interface


#pragma mark - Keyed Archiving

- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:source_ forKey:@"source"];
    [encoder encodeObject:target_ forKey:@"target"];
    [encoder encodeFloat:length_ forKey:@"length"];
    [encoder encodeObject:index_ forKey:@"index"];
    [encoder encodeObject:data_ forKey:@"data"];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        source_ = [[decoder decodeObjectForKey:@"source"] retain];
        target_ = [[decoder decodeObjectForKey:@"target"] retain];
        length_ = [decoder decodeFloatForKey:@"length"];
        index_  = [[decoder decodeObjectForKey:@"index"] retain];
        data_   = [[decoder decodeObjectForKey:@"data"] retain];
        
        
        nextEdgeIndex_  = MIN(nextEdgeIndex_, ([index_ integerValue] - 1));
    }
        
    return self;
}

@end
