//
//  ATParticle.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATNode.h"

@interface ATParticle : ATNode
{
    
@private
    CGPoint     velocity_;
    CGPoint     force_;
    CGFloat     tempMass_;
    
    NSUInteger  connections_;
}

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint force;
@property (nonatomic, assign) CGFloat tempMass;
@property (nonatomic, assign) NSUInteger connections;

- (id) init;

- (id) initWithVelocity:(CGPoint)velocity 
                  force:(CGPoint)force 
               tempMass:(CGFloat)tempMass;

- (void) applyForce:(CGPoint)force;

@end
