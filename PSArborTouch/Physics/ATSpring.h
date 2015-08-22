//
//  ATSpring.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATEdge.h"

@class ATParticle;

@interface ATSpring : ATEdge

@property (nonatomic, readonly, strong) ATParticle *point1;
@property (nonatomic, readonly, strong) ATParticle *point2;

@property (nonatomic, assign) CGFloat stiffness;

- (CGFloat) distanceToParticle:(ATParticle *)particle;

@end
