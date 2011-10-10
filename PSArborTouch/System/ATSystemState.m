//
//  ATSystemState.m
//  PSArborTouch
//
//  Created by Ed Preston on 30/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATSystemState.h"

#import "ATEdge.h"
#import "ATNode.h"


@interface ATSystemState ()

@end


@implementation ATSystemState

//@synthesize nodes       = nodes_;
- (NSArray *) nodes
{
    return [nodes_ allValues];
}

//@synthesize edges       = edges_;
- (NSArray *) edges
{
    return [edges_ allValues];
}

//@synthesize adjacency   = adjacency_;
- (NSArray *) adjacency
{
    return [adjacency_ allValues]; 
}

//@synthesize names       = names_;
- (NSArray *) names
{
    return [names_ allValues]; 
}

- (id) init
{
    self = [super init];
    if (self) {
        nodes_      = [[NSMutableDictionary dictionaryWithCapacity:32] retain];      
        edges_      = [[NSMutableDictionary dictionaryWithCapacity:32] retain];      
        adjacency_  = [[NSMutableDictionary dictionaryWithCapacity:32] retain];             
        names_      = [[NSMutableDictionary dictionaryWithCapacity:32] retain];
    }
    
    return self;
}

- (void) dealloc
{
    [adjacency_ release];
    [edges_ release];
    [names_ release];
    [nodes_ release];
    
    [super dealloc];
}

#pragma mark - Nodes

- (void) setNodesObject:(ATNode *)NodesObject forKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    NSParameterAssert(NodesObject != nil);
    
    if (NodesObject == nil || Key == nil) return;
    [nodes_ setObject:NodesObject forKey:Key];
}

- (void) removeNodesObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return;
    [nodes_ removeObjectForKey:Key];
}

- (ATNode *) getNodesObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return nil;
    return [nodes_ objectForKey:Key];
}

#pragma mark - Edges

- (void) setEdgesObject:(ATEdge *)EdgesObject forKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    NSParameterAssert(EdgesObject != nil);
    
    if (EdgesObject == nil || Key == nil) return;
    [edges_ setObject:EdgesObject forKey:Key];
}

- (void) removeEdgesObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return;
    [edges_ removeObjectForKey:Key];
}

- (ATEdge *) getEdgesObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return nil;
    return [edges_ objectForKey:Key];
}


#pragma mark - Adjacency

- (void) setAdjacencyObject:(NSMutableDictionary *)AdjacencyObject forKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    NSParameterAssert(AdjacencyObject != nil);
    
    if (AdjacencyObject == nil || Key == nil) return;
    [adjacency_ setObject:AdjacencyObject forKey:Key];
}

- (void) removeAdjacencyObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return;
    [adjacency_ removeObjectForKey:Key];
}

- (NSMutableDictionary *) getAdjacencyObjectForKey:(NSNumber *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return nil;
    return [adjacency_ objectForKey:Key];
}


#pragma mark - Names

- (void) setNamesObject:(ATNode *)NamesObject forKey:(NSString *)Key
{
    NSParameterAssert(Key != nil);
    NSParameterAssert(NamesObject != nil);
    
    if (NamesObject == nil || Key == nil) return;
    [names_ setObject:NamesObject forKey:Key];
}

- (void) removeNamesObjectForKey:(NSString *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return;
    [names_ removeObjectForKey:Key];
}

- (ATNode *) getNamesObjectForKey:(NSString *)Key
{
    NSParameterAssert(Key != nil);
    
    if (Key == nil) return nil;
    return [names_ objectForKey:Key];
}



#pragma mark - Keyed Archiving


- (void) encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:nodes_ forKey:@"nodes"];
    [encoder encodeObject:edges_ forKey:@"edges"];
    [encoder encodeObject:adjacency_ forKey:@"adjacency"];
    [encoder encodeObject:names_ forKey:@"names"];
}

- (id) initWithCoder:(NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        nodes_      = [[decoder decodeObjectForKey:@"nodes"] retain];
        edges_      = [[decoder decodeObjectForKey:@"edges"] retain];
        adjacency_  = [[decoder decodeObjectForKey:@"adjacency"] retain];
        names_      = [[decoder decodeObjectForKey:@"names"] retain];
    }
    return self;
}

@end
