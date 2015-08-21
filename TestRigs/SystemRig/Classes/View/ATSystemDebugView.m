//
//  ATSystemDebugView.m
//  SystemRig - System Test / Debug Rig
//
//  Created by Ed Preston on 1/10/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATSystemDebugView.h"

#import "ATSystem.h"
#import "ATPhysics.h"
#import "ATBarnesHutTree.h"
#import "ATBarnesHutBranch.h"
#import "ATSpring.h"
#import "ATParticle.h"


@interface ATSystemDebugView ()

- (CGSize) sizeToScreen:(CGSize)s;
- (CGPoint) pointToScreen:(CGPoint)p;
- (CGRect) scaleRect:(CGRect)rect;
- (void) drawLineWithContext:(CGContextRef)context from:(CGPoint)from to:(CGPoint)to;
- (void) drawOutlineWithContext:(CGContextRef)context andRect:(CGRect)rect;
- (void) recursiveDrawBranches:(ATBarnesHutBranch *)branch inContext:(CGContextRef)context;
- (void) drawSpring:(ATSpring *)spring inContext:(CGContextRef)context;
- (void) drawParticle:(ATParticle *)particle inContext:(CGContextRef)context;

@end


@implementation ATSystemDebugView


- (void) layoutSubviews
{
    self.system.viewBounds = self.bounds;
}

- (void) drawRect:(CGRect)rect
{
    if ( self.system ) {
        
        CGContextRef context = UIGraphicsGetCurrentContext(); 
        
        if (self.isDebugDrawing) {
            CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0); // yellow line
            CGContextSetLineWidth(context, 1.0);
            
            // Drawing code for the barnes-hut trees
            ATBarnesHutBranch *root = self.system.physics.bhTree.root;
            
            if ( root ) {
                [self recursiveDrawBranches:root inContext:context];
            }
            
            
            CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0); // green line
            CGContextSetLineWidth(context, 1.0);
            
            [self drawOutlineWithContext:context andRect:[self scaleRect:self.system.tweenBoundsTarget]];
            
            
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 1.0); // blue line
            CGContextSetLineWidth(context, 1.0);
            
            [self drawOutlineWithContext:context andRect:[self scaleRect:self.system.tweenBoundsCurrent]];
        }
        
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5); // black line with alpha
        CGContextSetLineWidth(context, 2.0);
        
        // Drawing code for springs
        for (ATSpring *spring in self.system.physics.springs) {
            [self drawSpring:spring inContext:context];            
        }
        
        
        CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0); // red line
        CGContextSetLineWidth(context, 2.0);
        
        // Drawing code for particle centers
        for (ATParticle *particle in self.system.physics.particles) {
            [self drawParticle:particle inContext:context];            
        }
        
    }
}


#pragma mark - Internal Interface

- (CGSize) sizeToScreen:(CGSize)s 
{
//    return [self.system toViewSize:s];
    
    CGSize size = self.bounds.size;
    
    CGFloat scaleX = size.width / 20;
    CGFloat scaleY = size.height / 20;
    
    CGFloat sx  = (s.width * scaleX);
    CGFloat sy  = (s.height * scaleY);
    
    return CGSizeMake(sx, sy);
}

- (CGPoint) pointToScreen:(CGPoint)p 
{
//    return [self.system toViewPoint:p];
    
    CGSize size = self.bounds.size;
    CGFloat midX = size.width / 2;
    CGFloat midY = size.height / 2;
    
    CGFloat scaleX = size.width / 20;
    CGFloat scaleY = size.height / 20;
    
    CGFloat sx  = (p.x * scaleX) + midX;
    CGFloat sy  = (p.y * scaleY) + midY;
    
    return CGPointMake(sx, sy);
}

- (CGRect) scaleRect:(CGRect)rect
{
    CGRect ret;
    
    ret.origin  = [self pointToScreen:rect.origin];
    ret.size    = [self sizeToScreen:rect.size];
    
    return ret;
}

- (void) drawLineWithContext:(CGContextRef)context from:(CGPoint)from to:(CGPoint)to
{
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, from.x, from.y);
    
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context); // do actual stroking
}

- (void) drawOutlineWithContext:(CGContextRef)context andRect:(CGRect)rect
{
    CGContextBeginPath(context);
    
    CGContextAddRect(context, rect);
    
    CGContextStrokePath(context); // do actual stroking
}

- (void) recursiveDrawBranches:(ATBarnesHutBranch *)branch inContext:(CGContextRef)context
{    
    // Draw the rect
    [self drawOutlineWithContext:context andRect:[self scaleRect:branch.bounds]];
    
    // Draw any sub branches
    if (branch.se != nil && [branch.se isKindOfClass:ATBarnesHutBranch.class] == YES) {
        [self recursiveDrawBranches:branch.se inContext:context];
    }
    
    if (branch.sw != nil && [branch.sw isKindOfClass:ATBarnesHutBranch.class] == YES ) {
        [self recursiveDrawBranches:branch.sw inContext:context];
    }
    
    if (branch.ne != nil && [branch.ne isKindOfClass:ATBarnesHutBranch.class] == YES ) {
        [self recursiveDrawBranches:branch.ne inContext:context];
    }
    
    if (branch.nw != nil && [branch.nw isKindOfClass:ATBarnesHutBranch.class] == YES ) {
        [self recursiveDrawBranches:branch.nw inContext:context];
    }
    
}

- (void) drawSpring:(ATSpring *)spring inContext:(CGContextRef)context
{
    
    [self drawLineWithContext:context 
                         from:[self pointToScreen:spring.point1.position] 
                           to:[self pointToScreen:spring.point2.position]];
    
}

- (void) drawParticle:(ATParticle *)particle inContext:(CGContextRef)context
{
    // Translate the particle position to screen coordinates
    CGPoint pOrigin = [self pointToScreen:particle.position];
    
    // Create an empty rect at particle center
    CGRect strokeRect = CGRectMake(pOrigin.x, pOrigin.y, 0.0, 0.0);
    
    // Expand the rect around the center
    strokeRect = CGRectInset(strokeRect, -5.0, -5.0);
    
    // Draw the rect    
    CGContextStrokeRect(context, strokeRect);
}


@end
