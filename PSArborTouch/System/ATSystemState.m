//
//  ATSystemState.m
//  SystemRig
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

@synthesize nodes       = nodes_;
@synthesize edges       = edges_;
@synthesize adjacency   = adjacency_;
@synthesize names       = names_;

- (id)init
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

- (void)dealloc
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
    [nodes_ setObject:NodesObject forKey:Key];
}

- (void) removeNodesObjectForKey:(NSNumber *)Key
{
    [nodes_ removeObjectForKey:Key];
}

- (ATNode *) getNodesObjectForKey:(NSNumber *)Key
{
    return [[self nodes] objectForKey:Key];
}

#pragma mark - Edges

- (void) setEdgesObject:(ATEdge *)EdgesObject forKey:(NSNumber *)Key
{
    [edges_ setObject:EdgesObject forKey:Key];
}

- (void) removeEdgesObjectForKey:(NSNumber *)Key
{
    [edges_ removeObjectForKey:Key];
}

- (ATEdge *) getEdgesObjectForKey:(NSNumber *)Key
{
    return [edges_ objectForKey:Key];
}


#pragma mark - Adjacency

- (void) setAdjacencyObject:(NSMutableDictionary *)AdjacencyObject forKey:(NSNumber *)Key
{
    [adjacency_ setObject:AdjacencyObject forKey:Key];
}

- (void) removeAdjacencyObjectForKey:(NSNumber *)Key
{
    [adjacency_ removeObjectForKey:Key];
}

- (NSMutableDictionary *) getAdjacencyObjectForKey:(NSNumber *)Key
{
    return [[self adjacency] objectForKey:Key];
}


#pragma mark - Names

- (void) setNamesObject:(ATNode *)NamesObject forKey:(NSString *)Key
{
    [names_ setObject:NamesObject forKey:Key];
}

- (void) removeNamesObjectForKey:(NSString *)Key
{
    [names_ removeObjectForKey:Key];
}

- (ATNode *) getNamesObjectForKey:(NSString *)Key
{
    return [names_ objectForKey:Key];
}



#pragma mark - Keyed Archiving


- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:nodes_ forKey:@"nodes"];
    [encoder encodeObject:edges_ forKey:@"edges"];
    [encoder encodeObject:adjacency_ forKey:@"adjacency"];
    [encoder encodeObject:names_ forKey:@"names"];
}

- (id)initWithCoder:(NSCoder *)decoder 
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
