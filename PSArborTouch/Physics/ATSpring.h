//
//  ATSpring.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

// #import "ATEdge.h"


@class ATParticle;

@interface ATSpring : NSObject // ATEdge
{
    
@private
    ATParticle *_point1;
    ATParticle *_point2;
    CGFloat     _length;
    CGFloat     _stiffness;
    
}

@property (nonatomic, retain) ATParticle *point1;
@property (nonatomic, retain) ATParticle *point2;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, assign) CGFloat stiffness;
- (id) init;
- (id) initWithPoint1:(ATParticle *)point1 
               point2:(ATParticle *)point2 
               length:(CGFloat)length 
            stiffness:(CGFloat)stiffness;


- (CGFloat) distanceToParticle:(ATParticle *)particle;

@end
