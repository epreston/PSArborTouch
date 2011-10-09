//
//  AtlasCanvasView.m
//  Atlas
//
//  Created by Ed Preston on 4/10/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "AtlasCanvasView.h"


#import "ATSystem.h"
#import "ATPhysics.h"
#import "ATBarnesHutTree.h"
#import "ATBarnesHutBranch.h"
#import "ATSpring.h"
#import "ATParticle.h"


@interface AtlasCanvasView ()

- (CGSize) sizeToScreen:(CGSize)s;
- (CGPoint) pointToScreen:(CGPoint)p;
- (CGRect) scaleRect:(CGRect)rect;
- (void) drawLineWithContext:(CGContextRef)context from:(CGPoint)from to:(CGPoint)to;
- (void) drawOutlineWithContext:(CGContextRef)context andRect:(CGRect)rect;
- (void) recursiveDrawBranches:(ATBarnesHutBranch *)branch inContext:(CGContextRef)context;
- (void) drawSpring:(ATSpring *)spring inContext:(CGContextRef)context;
- (void) drawParticle:(ATParticle *)particle inContext:(CGContextRef)context;
- (void) drawParticleText:(ATParticle *)particle inContext:(CGContextRef)context;
- (UIFont *)font;

@end


@implementation AtlasCanvasView

@synthesize system = system_;
@synthesize debugDrawing = debugDrawing_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) dealloc
{
    [font_ release];
    [system_ release];
    
    [super dealloc];
}

- (void) layoutSubviews
{
    // Handle size changes
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
            
            // Draw bounds target (due to translation will always be the outeredge in display)
            CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0); // green line
            CGContextSetLineWidth(context, 1.0);
            
            [self drawOutlineWithContext:context andRect:[self scaleRect:self.system.tweenBoundsTarget]];
            
            // Draw bounds current (this is a relative representation of the view window you see
            // with all the nodes. It shows what the "camera" is doing to keep elements centered in
            // view)
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 1.0); // blue line
            CGContextSetLineWidth(context, 1.0);
            
            [self drawOutlineWithContext:context andRect:[self scaleRect:self.system.tweenBoundsCurrent]];
        }
        
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0); // black line
        CGContextSetLineWidth(context, 1.0);
        
        // Drawing code for springs
        for (ATSpring *spring in self.system.physics.springs) {
            [self drawSpring:spring inContext:context];            
        }
        
        CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0); // red line for node box
        CGContextSetLineWidth(context, 2.0);
        
        // Drawing code for particle centers
        for (ATParticle *particle in self.system.physics.particles) {
            
            [self drawParticleText:particle inContext:context];
            
//            [self drawParticle:particle inContext:context];            
        }
        
    }
}


#pragma mark - Internal Interface

- (CGSize) sizeToScreen:(CGSize)s 
{
    return [self.system toViewSize:s];
}

- (CGPoint) pointToScreen:(CGPoint)p 
{
    return [self.system toViewPoint:p];
}

- (CGRect) scaleRect:(CGRect)rect
{
    return [system_ toViewRect:rect];
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

- (void) drawParticleText:(ATParticle *)particle inContext:(CGContextRef)context
{
    // Translate the particle position to screen coordinates
    CGPoint pOrigin = [self pointToScreen:particle.position];
    
    // Create an empty rect at particle center
    CGRect fillRect = CGRectMake(pOrigin.x, pOrigin.y, 0.0, 0.0);
    
    // Expand the rect around the center
    fillRect = CGRectInset(fillRect, -10.0, -8.0);
    
    
    // Fill in the rect with current fill color
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0); // white fill color (we use black for text)
    CGContextFillRect(context, fillRect);
    
    // Set the text fill color
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); // black
    
    // Draw the text label
    [particle.name drawInRect:fillRect 
                     withFont:[self font] 
                lineBreakMode:UILineBreakModeTailTruncation
                    alignment:UITextAlignmentCenter];
    
}

- (UIFont *)font
{
    // Cache the fond we are using
    if (font_ == nil) {
        font_ = [UIFont fontWithName:@"Arial" size:11.0];
    }
    
    return font_; 
}


@end
