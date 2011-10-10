//
//  ATSystemState.h
//  PSArborTouch
//
//  Created by Ed Preston on 30/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATNode;
@class ATEdge;

@interface ATSystemState : NSObject <NSCoding>
{
    
@private
//    *nodes;      // lookup based on node _id's from the worker
//    *edges;      // likewise
//    *adjacency;  // NSMutableDictionary (_id of source) -> NSMutableDictionary (_id of target) -> Edge
//    *names;      // lookup table based on 'name' field in data objects
    
    NSMutableDictionary *nodes_;
    NSMutableDictionary *edges_;
    NSMutableDictionary *adjacency_;
    NSMutableDictionary *names_;
}

@property (nonatomic, readonly, retain) NSArray *nodes;
- (void) setNodesObject:(ATNode *)NodesObject forKey:(NSNumber *)Key;
- (void) removeNodesObjectForKey:(NSNumber *)Key;
- (ATNode *) getNodesObjectForKey:(NSNumber *)Key;

@property (nonatomic, readonly, retain) NSArray *edges;
- (void) setEdgesObject:(ATEdge *)EdgesObject forKey:(NSNumber *)Key;
- (void) removeEdgesObjectForKey:(NSNumber *)Key;
- (ATEdge *) getEdgesObjectForKey:(NSNumber *)Key;

@property (nonatomic, readonly, retain) NSArray *adjacency;
- (void) setAdjacencyObject:(NSMutableDictionary *)AdjacencyObject forKey:(NSNumber *)Key;
- (void) removeAdjacencyObjectForKey:(NSNumber *)Key;
- (NSMutableDictionary *) getAdjacencyObjectForKey:(NSNumber *)Key;

@property (nonatomic, readonly, retain) NSArray *names;
- (void) setNamesObject:(ATNode *)NamesObject forKey:(NSString *)Key;
- (void) removeNamesObjectForKey:(NSString *)Key;
- (ATNode *) getNamesObjectForKey:(NSString *)Key;


@end
