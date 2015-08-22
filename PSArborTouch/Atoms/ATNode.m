//
//  ATNode.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATNode.h"

// Nodes have positive indexes, Edges have negative indexes
static NSInteger _nextNodeIndex = 1; 


@interface ATNode ()
// Reserved
@end


@implementation ATNode

- (instancetype) init
{
    self = [super init];
    if (self) {
        _index      = @(_nextNodeIndex++);
        _name       = nil;
        _mass       = 1.0;
        _position   = CGPointZero;
        _fixed      = NO;
        _userData   = nil;
    }
    return self;
}

- (instancetype) initWithName:(NSString *)name mass:(CGFloat)mass position:(CGPoint)position fixed:(BOOL)fixed
{
    self = [self init];
    if (self) {
        _name       = [name copy];
        _mass       = mass;
        _position   = position;
        _fixed      = fixed;
    }
    return self;
}

- (instancetype) initWithName:(NSString *)name userData:(NSMutableDictionary *)data
{
    // TODO: This method should be reviewed. Does not produce a useable object.
    // Is this a general user data store or keyed archiving style object creation?
    self = [self init];
    if (self) {
        _name       = [name copy];
        _userData   = data;
    }
    return self;
}


#pragma mark - Keyed Archiving

- (void) encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeFloat:_mass forKey:@"mass"];
    [encoder encodeCGPoint:_position forKey:@"position"];
    [encoder encodeBool:_fixed forKey:@"fixed"];
    [encoder encodeObject:_index forKey:@"index"];
    [encoder encodeObject:_userData forKey:@"data"];
}

- (instancetype) initWithCoder:(NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        _name       = [decoder decodeObjectForKey:@"name"];
        _mass       = [decoder decodeFloatForKey:@"mass"];
        _position   = [decoder decodeCGPointForKey:@"position"];
        _fixed      = [decoder decodeBoolForKey:@"fixed"];
        _index      = [decoder decodeObjectForKey:@"index"];
        _userData   = [decoder decodeObjectForKey:@"data"];
        
        _nextNodeIndex  = MAX(_nextNodeIndex, ([_index integerValue] + 1));
    }
    
    return self;
}

@end
