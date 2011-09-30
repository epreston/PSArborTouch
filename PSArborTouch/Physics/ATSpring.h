//
//  ATSpring.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATEdge.h"

@class ATParticle;

@interface ATSpring : ATEdge
{
    
@private
    CGFloat     stiffness_;
}

@property (nonatomic, readonly, retain) ATParticle *point1;
@property (nonatomic, readonly, retain) ATParticle *point2;

@property (nonatomic, assign) CGFloat stiffness;

- (id) init;

- (CGFloat) distanceToParticle:(ATParticle *)particle;

@end
