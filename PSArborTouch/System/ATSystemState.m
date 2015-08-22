//
//  ATSystemState.m
//  PSArborTouch
//
//  Created by Ed Preston on 30/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATSystemState.h"

#import "ATEdge.h"
#import "ATNode.h"


@interface ATSystemState ()
{
    
@private
    //    *nodes;      // lookup based on node _id's from the worker
    //    *edges;      // likewise
    //    *adjacency;  // NSMutableDictionary (_id of source) -> NSMutableDictionary (_id of target) -> Edge
    //    *names;      // lookup table based on 'name' field in data objects
    
    NSMutableDictionary *_nodes;
    NSMutableDictionary *_edges;
    NSMutableDictionary *_adjacency;
    NSMutableDictionary *_names;
}
@end


@implementation ATSystemState

//@synthesize nodes       = nodes_;
- (NSArray *) nodes
{
    return [_nodes allValues];
}

//@synthesize edges       = edges_;
- (NSArray *) edges
{
    return [_edges allValues];
}

//@synthesize adjacency   = adjacency_;
- (NSArray *) adjacency
{
    return [_adjacency allValues]; 
}

//@synthesize names       = names_;
- (NSArray *) names
{
    return [_names allValues]; 
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        _nodes      = [NSMutableDictionary dictionaryWithCapacity:32];      
        _edges      = [NSMutableDictionary dictionaryWithCapacity:32];      
        _adjacency  = [NSMutableDictionary dictionaryWithCapacity:32];             
        _names      = [NSMutableDictionary dictionaryWithCapacity:32];
    }
    
    return self;
}


#pragma mark - Nodes

- (void) setNodesObject:(ATNode *)NodesObject forKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    NSParameterAssert(NodesObject != nil);
    
    if (NodesObject == nil || Key == nil) return;
    _nodes[Key] = NodesObject;
}

- (void) removeNodesObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return;
    [_nodes removeObjectForKey:Key];
}

- (ATNode *) getNodesObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return nil;
    return _nodes[Key];
}


#pragma mark - Edges

- (void) setEdgesObject:(ATEdge *)EdgesObject forKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    NSParameterAssert(EdgesObject != nil);
    
    if (EdgesObject == nil || Key == nil) return;
    _edges[Key] = EdgesObject;
}

- (void) removeEdgesObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return;
    [_edges removeObjectForKey:Key];
}

- (ATEdge *) getEdgesObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return nil;
    return _edges[Key];
}


#pragma mark - Adjacency

- (void) setAdjacencyObject:(NSMutableDictionary *)AdjacencyObject forKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    NSParameterAssert(AdjacencyObject != nil);
    
    if (AdjacencyObject == nil || Key == nil) return;
    _adjacency[Key] = AdjacencyObject;
}

- (void) removeAdjacencyObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return;
    [_adjacency removeObjectForKey:Key];
}

- (NSMutableDictionary *) getAdjacencyObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return nil;
    return _adjacency[Key];
}


#pragma mark - Names

- (void) setNamesObject:(ATNode *)NamesObject forKey:(NSString *)Key
{
    NSParameterAssert(Key != nil);
    NSParameterAssert(NamesObject != nil);
    
    if (NamesObject == nil || Key == nil) return;
    _names[Key] = NamesObject;
}

- (void) removeNamesObjectForKey:(NSString *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return;
    [_names removeObjectForKey:Key];
}

- (ATNode *) getNamesObjectForKey:(NSString *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return nil;
    return _names[Key];
}


#pragma mark - Keyed Archiving

- (void) encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:_nodes forKey:@"nodes"];
    [encoder encodeObject:_edges forKey:@"edges"];
    [encoder encodeObject:_adjacency forKey:@"adjacency"];
    [encoder encodeObject:_names forKey:@"names"];
}

- (instancetype) initWithCoder:(NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        _nodes      = [decoder decodeObjectForKey:@"nodes"];
        _edges      = [decoder decodeObjectForKey:@"edges"];
        _adjacency  = [decoder decodeObjectForKey:@"adjacency"];
        _names      = [decoder decodeObjectForKey:@"names"];
    }
    return self;
}

@end
