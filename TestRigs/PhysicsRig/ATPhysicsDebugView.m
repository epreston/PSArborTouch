//
//  ATPhysicsDebugView.m
//  PSArborTouch - Physics Test / Debug Rig
//
//  Created by Ed Preston on 21/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATPhysicsDebugView.h"
#import "ATPhysics.h"
#import "ATBarnesHutTree.h"
#import "ATBarnesHutBranch.h"
#import "ATSpring.h"
#import "ATParticle.h"

@implementation ATPhysicsDebugView

@synthesize physics = _physics;
@synthesize debugDrawing = _debugDrawing;


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) dealloc
{
    [_physics release];
    
    [super dealloc];
}


- (CGSize) sizeToScreen:(CGSize)s 
{
    CGSize size = self.bounds.size;

    CGFloat scaleX = size.width / 10;
    CGFloat scaleY = size.height / 10;
    
    CGFloat sx  = (s.width * scaleX);
    CGFloat sy  = (s.height * scaleY);
    
    return CGSizeMake(sx, sy);
}


- (CGPoint) pointToScreen:(CGPoint)p 
{
    CGSize size = self.bounds.size;
    
    CGFloat midX = size.width / 2;
    CGFloat midY = size.height / 2;
    
    CGFloat scaleX = size.width / 10;
    CGFloat scaleY = size.height / 10;
    
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
    // Translate bounds by position
    CGRect rect;
    
//    rect.origin = CGPointMake(branch.bounds.origin.x + branch.position.x,
//                              branch.bounds.origin.y + branch.position.y);
    
    rect.origin = branch.bounds.origin;
    rect.size   = branch.bounds.size;
    
    // Draw the rect
    [self drawOutlineWithContext:context andRect:[self scaleRect:rect]];
    
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


- (void) drawRect:(CGRect)rect
{
    if ( self.physics ) {
        
        CGContextRef context = UIGraphicsGetCurrentContext(); 
        
        if (self.isDebugDrawing) {
            CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0); // yellow line
            CGContextSetLineWidth(context, 3.0);
            
            // Drawing code for the barnes-hut trees
            ATBarnesHutBranch *root = self.physics.bhTree.root;
            [self recursiveDrawBranches:root inContext:context];
        }
        
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5); // black line
        CGContextSetLineWidth(context, 2.0);
        
        // Drawing code for springs
        for (ATSpring *spring in self.physics.springs) {
            [self drawSpring:spring inContext:context];            
        }
    }
}


@end
