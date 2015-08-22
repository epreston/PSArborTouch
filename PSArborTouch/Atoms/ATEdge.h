//
//  ATEdge.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATNode;

@interface ATEdge : NSObject <NSCoding>

@property (nonatomic, readonly, strong) ATNode *source;
@property (nonatomic, readonly, strong) ATNode *target;
@property (nonatomic, assign) CGFloat length;

@property (nonatomic, readonly, strong) NSNumber *index;

@property (nonatomic, strong) NSMutableDictionary *userData;


- (instancetype) initWithSource:(ATNode *)source
                         target:(ATNode *)target
                         length:(CGFloat)length;

- (instancetype) initWithSource:(ATNode *)source
                         target:(ATNode *)target
                       userData:(NSMutableDictionary *)data;

- (CGFloat) distanceToNode:(ATNode *)node;

@end
