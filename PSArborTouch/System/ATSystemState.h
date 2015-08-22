//
//  ATSystemState.h
//  PSArborTouch
//
//  Created by Ed Preston on 30/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATNode;
@class ATEdge;

@interface ATSystemState : NSObject <NSCoding>

@property (nonatomic, readonly, strong) NSArray *nodes;
- (void) setNodesObject:(ATNode *)NodesObject forKey:(NSNumber *)Key;
- (void) removeNodesObjectForKey:(NSNumber *)Key;
- (ATNode *) getNodesObjectForKey:(NSNumber *)Key;

@property (nonatomic, readonly, strong) NSArray *edges;
- (void) setEdgesObject:(ATEdge *)EdgesObject forKey:(NSNumber *)Key;
- (void) removeEdgesObjectForKey:(NSNumber *)Key;
- (ATEdge *) getEdgesObjectForKey:(NSNumber *)Key;

@property (nonatomic, readonly, strong) NSArray *adjacency;
- (void) setAdjacencyObject:(NSMutableDictionary *)AdjacencyObject forKey:(NSNumber *)Key;
- (void) removeAdjacencyObjectForKey:(NSNumber *)Key;
- (NSMutableDictionary *) getAdjacencyObjectForKey:(NSNumber *)Key;

@property (nonatomic, readonly, strong) NSArray *names;
- (void) setNamesObject:(ATNode *)NamesObject forKey:(NSString *)Key;
- (void) removeNamesObjectForKey:(NSString *)Key;
- (ATNode *) getNamesObjectForKey:(NSString *)Key;


@end
