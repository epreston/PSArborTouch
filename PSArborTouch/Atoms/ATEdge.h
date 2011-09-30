//
//  ATEdge.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATNode;

@interface ATEdge : NSObject <NSCoding>
{
    
@private
    ATNode     *source_;
    ATNode     *target_;
    CGFloat     length_;
    
    NSNumber   *index_;
    
    NSMutableDictionary *data_;
}

@property (nonatomic, readonly, retain) ATNode *source;
@property (nonatomic, readonly, retain) ATNode *target;
@property (nonatomic, assign) CGFloat length;

@property (nonatomic, readonly, retain) NSNumber *index;

@property (nonatomic, retain) NSMutableDictionary *userData;

- (id) init;

- (id) initWithSource:(ATNode *)source 
               target:(ATNode *)target 
               length:(CGFloat)length;

- (id) initWithSource:(ATNode *)source
               target:(ATNode *)target
             userData:(NSMutableDictionary *)data;

- (CGFloat) distanceToNode:(ATNode *)node;

@end
