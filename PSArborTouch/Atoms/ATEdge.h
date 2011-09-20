//
//  ATEdge.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATNode;

@interface ATEdge : NSObject
{
    
@private
    ATNode     *_source;
    ATNode     *_target;
    CGFloat     _length;
}

@property (nonatomic, retain) ATNode *source;
@property (nonatomic, retain) ATNode *target;
@property (nonatomic, assign) CGFloat length;

- (id)init;
- (id)initWithSource:(ATNode *)source target:(ATNode *)target length:(CGFloat)length;

@end
