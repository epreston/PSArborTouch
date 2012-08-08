//
//  ATNode.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATNode.h"

// Nodes have positive indexes, Edges have negative indexes
static NSInteger nextNodeIndex_ = 1; 


@interface ATNode ()
// Reserved
@end


@implementation ATNode

@synthesize name        = name_;
@synthesize index       = index_;
@synthesize mass        = mass_;
@synthesize position    = position_;
@synthesize fixed       = fixed_;
@synthesize userData    = data_;

- (id) init
{
    self = [super init];
    if (self) {
        index_      = [@(nextNodeIndex_++) retain];
        name_       = nil;
        mass_       = 1.0;
        position_   = CGPointZero;
        fixed_      = NO;
        data_       = nil;
    }
    return self;
}

- (id) initWithName:(NSString *)name mass:(CGFloat)mass position:(CGPoint)position fixed:(BOOL)fixed 
{
    self = [self init];
    if (self) {
        name_       = [name copy];
        mass_       = mass;
        position_   = position;
        fixed_      = fixed;
    }
    return self;
}

- (id) initWithName:(NSString *)name userData:(NSMutableDictionary *)data 
{
    self = [self init];
    if (self) {
        name_ = [name copy];
        data_ = [data retain];
    }
    return self;
}

- (void) dealloc
{
    [data_ release];
    
    [name_ release];
    [index_ release];
    
    [super dealloc];
}


#pragma mark - Internal Interface


#pragma mark - Keyed Archiving

- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:name_ forKey:@"name"];
    [encoder encodeFloat:mass_ forKey:@"mass"];
    [encoder encodeCGPoint:position_ forKey:@"position"];
    [encoder encodeBool:fixed_ forKey:@"fixed"];
    [encoder encodeObject:index_ forKey:@"index"];
    [encoder encodeObject:data_ forKey:@"data"];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        name_       = [[decoder decodeObjectForKey:@"name"] retain];
        mass_       = [decoder decodeFloatForKey:@"mass"];
        position_   = [decoder decodeCGPointForKey:@"position"];
        fixed_      = [decoder decodeBoolForKey:@"fixed"];
        index_      = [[decoder decodeObjectForKey:@"index"] retain];
        data_       = [[decoder decodeObjectForKey:@"data"] retain];
        
        nextNodeIndex_  = MAX(nextNodeIndex_, ([index_ integerValue] + 1));
    }
    
    return self;
}

@end
