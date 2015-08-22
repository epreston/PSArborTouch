//
//  ATEdge.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATEdge.h"
#import "ATNode.h"

#import "ATGeometry.h"

// Edges have negative indexes, Nodes have positive indexes,
static NSInteger _nextEdgeIndex = -1;


@interface ATEdge ()
// Reserved
@end


@implementation ATEdge

- (instancetype) init
{
    self = [super init];
    if (self) {
        _index      = @(_nextEdgeIndex--);
        _source     = nil;
        _target     = nil;
        _length     = 1.0;
        _userData   = nil;
    }
    return self;
}

- (instancetype) initWithSource:(ATNode *)source target:(ATNode *)target length:(CGFloat)length
{
    self = [self init];
    if (self) {
        _source = source;
        _target = target;
        _length = length;
    }
    return self;
}

- (instancetype) initWithSource:(ATNode *)source target:(ATNode *)target userData:(NSMutableDictionary *)data
{
    // TODO: Review this method, does it make sense that length is excluded ?
    self = [self init];
    if (self) {
        _source     = source;
        _target     = target;
        _userData   = data;
    }
    return self;
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


#pragma mark - Keyed Archiving

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_source forKey:@"source"];
    [encoder encodeObject:_target forKey:@"target"];
    [encoder encodeFloat:_length forKey:@"length"];
    [encoder encodeObject:_index forKey:@"index"];
    [encoder encodeObject:_userData forKey:@"data"];
}

- (instancetype) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        _source     = [decoder decodeObjectForKey:@"source"];
        _target     = [decoder decodeObjectForKey:@"target"];
        _length     = [decoder decodeFloatForKey:@"length"];
        _index      = [decoder decodeObjectForKey:@"index"];
        _userData   = [decoder decodeObjectForKey:@"data"];
        
        
        _nextEdgeIndex  = MIN(_nextEdgeIndex, ([_index integerValue] - 1));
    }
        
    return self;
}

@end
