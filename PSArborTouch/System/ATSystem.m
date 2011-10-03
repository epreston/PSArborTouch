//
//  ATSystem.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATSystem.h"
#import "ATSystemState.h"
#import "ATSystemParams.h"
#import "ATSpring.h"
#import "ATParticle.h"
#import "ATEdge.h"
#import "ATNode.h"
#import "ATGeometry.h"


@interface ATSystem ()

- (CGRect) ensureRect:(CGRect)rect minimumDimentions:(CGFloat)minimum;
- (CGRect) tweenRect:(CGRect)sourceRect toRect:(CGRect)targetRect delta:(CGFloat)delta;

@end


@implementation ATSystem

@synthesize state = state_;
@synthesize parameters = parameters_;

- (id) init
{
    self = [super init];
    if (self) {
        state_          = [[[ATSystemState alloc] init] retain];
        parameters_     = [[[ATSystemParams alloc] init] retain];
        viewBounds_     = CGRectZero;
        viewPadding_    = UIEdgeInsetsZero;
        viewTweenStep_  = 0.04;
    }
    return self;
}

- (id) initWithState:(ATSystemState *)state parameters:(ATSystemParams *)parameters 
{
    self = [self init];
    if (self) {
        state_      = [state retain];
        parameters_ = [parameters retain];
    }
    return self;
}

- (void) dealloc
{
    [state_ release];
    [parameters_ release];
    
    [super dealloc];
}


#pragma mark - Tween Debugging

@synthesize tweenBoundsCurrent = tweenBoundsCurrent_;
@synthesize tweenBoundsTarget = tweenBoundsTarget_;


#pragma mark - Viewport Management / Translation

@synthesize viewBounds      = viewBounds_;

- (void)setViewBounds:(CGRect)viewBounds
{
    viewBounds_ = viewBounds;
    [self updateViewport];
}

@synthesize viewPadding     = viewPadding_;
@synthesize viewTweenStep   = viewTweenStep_;


- (CGSize) toViewSize:(CGSize)physicsSize
{
    // Return the size in the physics coordinate system if we dont have a screen size or current
    // viewport bounds.
    if ( CGRectIsEmpty(viewBounds_) || CGRectIsEmpty(tweenBoundsCurrent_) ) {
        return physicsSize;
    }
    
    CGRect  fromBounds = self.simulationBounds;
//    CGRect  fromBounds = tweenBoundsCurrent_;
//    CGRect  fromBounds = tweenBoundsTarget_;
    
    // UIEdgeInsetsInsetRect
    CGFloat adjustedScreenWidth     = viewBounds_.size.width  - (viewPadding_.left + viewPadding_.right);
    CGFloat adjustedScreenHeight    = viewBounds_.size.height - (viewPadding_.top  + viewPadding_.bottom);
    
    
    CGFloat scaleX = physicsSize.width / fromBounds.size.width;
    CGFloat scaleY = physicsSize.height / fromBounds.size.height;
    
    CGFloat sx  = (adjustedScreenWidth * scaleX);
    CGFloat sy  = (adjustedScreenHeight * scaleY);
    
    return CGSizeMake(sx, sy);
}

- (CGPoint) toViewPoint:(CGPoint)physicsPoint
{
    // Return the point in the physics coordinate system if we dont have a screen size or current
    // viewport bounds.
    if ( CGRectIsEmpty(viewBounds_) || CGRectIsEmpty(tweenBoundsCurrent_) ) {
        return physicsPoint;
    }
    
    CGRect  fromBounds = self.simulationBounds;
//    CGRect  fromBounds = tweenBoundsCurrent_;
//    CGRect  fromBounds = tweenBoundsTarget_;
    
    // UIEdgeInsetsInsetRect
    CGFloat adjustedScreenWidth     = viewBounds_.size.width  - (viewPadding_.left + viewPadding_.right);
    CGFloat adjustedScreenHeight    = viewBounds_.size.height - (viewPadding_.top  + viewPadding_.bottom);
    
    CGFloat scaleX = (physicsPoint.x - fromBounds.origin.x) / fromBounds.size.width;
    CGFloat scaleY = (physicsPoint.y - fromBounds.origin.y) / fromBounds.size.height;
    
    CGFloat sx = scaleX * adjustedScreenWidth  + viewPadding_.right;
    CGFloat sy = scaleY * adjustedScreenHeight + viewPadding_.top;
    
    return CGPointMake(sx, sy);
}

- (CGPoint) fromViewPoint:(CGPoint)viewPoint
{
    // Return the point in the screen coordinate system if we dont have a screen size.
    if ( CGRectIsEmpty(viewBounds_) || CGRectIsEmpty(tweenBoundsCurrent_) ) {
        return viewPoint;
    }
    
    CGRect  toBounds = self.simulationBounds;
//    CGRect  toBounds = tweenBoundsCurrent_;
//    CGRect  toBounds = tweenBoundsTarget_;
    
    // UIEdgeInsetsInsetRect
    CGFloat adjustedScreenWidth     = viewBounds_.size.width  - (viewPadding_.left + viewPadding_.right);
    CGFloat adjustedScreenHeight    = viewBounds_.size.height - (viewPadding_.top  + viewPadding_.bottom);
    
    CGFloat scaleX = (viewPoint.x - viewPadding_.right) / adjustedScreenWidth;
    CGFloat scaleY = (viewPoint.y - viewPadding_.top)   / adjustedScreenHeight;
    
    CGFloat px = scaleX * toBounds.size.width  + toBounds.origin.x;
    CGFloat py = scaleY * toBounds.size.height + toBounds.origin.y;
    
    return CGPointMake(px, py);
}

- (ATNode *) nearestNodeToPoint:(CGPoint)viewPoint 
{  
    // Find the nearest node to a particular position
    CGPoint translatedPoint = CGPointZero;
    
    // if view bounds has been specified, presume viewPoint is in screen pixel
    // units and convert it back to the physics engine coordinates
    if ( CGRectIsEmpty(viewBounds_) == NO ) {
        translatedPoint = [self fromViewPoint:viewPoint];
    } else {
        translatedPoint = viewPoint;
    }
    
    ATNode *closestNode         = nil;
    CGFloat closestDistance     = FLT_MAX;
    CGFloat distance            = 0.0;
    
    for (ATNode *node in [self.state.nodes allValues]) {
        
        distance = CGPointMagnitude(CGPointSubtract(node.position, translatedPoint));
        
        if (distance < closestDistance) {
            closestNode = node;
            closestDistance = distance;
        }
    }
    
    return closestNode;
}

- (ATNode *) nearestNodeToPoint:(CGPoint)viewPoint withinRadius:(CGFloat)viewRadius;
{
    ATNode *closestNode = [self nearestNodeToPoint:viewPoint];
    if (closestNode) {
        // Find the nearest node to a particular position
        CGPoint translatedNodePoint = CGPointZero;
        
        // if view bounds has been specified, presume viewPoint is in screen pixel
        // units and convert it back to the physics engine coordinates
        if ( CGRectIsEmpty(viewBounds_) == NO ) {
            translatedNodePoint = [self toViewPoint:closestNode.position];
        } else {
            translatedNodePoint = closestNode.position;
        }
        
        CGFloat distance = CGPointMagnitude(CGPointSubtract(translatedNodePoint, viewPoint));
        
        if (distance > viewRadius) {
            closestNode = nil;
        }
    }
    
    return closestNode;
}


#pragma mark - Node Management

- (ATNode *) addNode:(NSString *)name withData:(NSMutableDictionary *)data 
{
    // name can not be nil, data can be nil
    if (name == nil) return nil;
    
    ATNode *priorNode = [self.state getNamesObjectForKey:name];
    if (priorNode != nil) {
        
        NSLog(@"Overwrote user data for a node... Be sure this is what you wanted.");
        
        priorNode.userData = data;
        return priorNode;
        
    } else {
        
        ATParticle *node = [[ATParticle alloc] initWithName:name userData:data];
        
        node.position = CGPointRandom(1.0);
        
        [self.state setNamesObject:node forKey:name];
        [self.state setNodesObject:node forKey:node.index];
        
        [self addParticle:node];
        
        return node;
    }
}

- (void) removeNode:(NSString *)nodeName 
{      
    // remove a node and its associated edges from the graph
    ATNode *node = [self getNode:nodeName];
    if (node != nil) {
        
        [self.state removeNodesObjectForKey:node.index];
        [self.state removeNamesObjectForKey:node.name];
        
        for (ATEdge *edge in [self.state.edges allValues]) {
            if (edge.source.index == node.index || edge.target.index == node.index) {
                [self removeEdge:edge];
            }
        }
        
        [self removeParticle:(ATParticle *)node];  // Note: Upcast
    }
}

- (ATNode *) getNode:(NSString *)nodeName 
{
    if (nodeName == nil) return nil;
    return [self.state getNamesObjectForKey:nodeName];
}


#pragma mark - Edge Management

- (ATEdge *) addEdgeFromNode:(NSString *)source toNode:(NSString *)target withData:(NSMutableDictionary*)data 
{
    ATNode *sourceNode = [self getNode:source];
    if (sourceNode == nil) {
        sourceNode = [self addNode:source withData:nil];
    }
    
    ATNode *targetNode = [self getNode:target];
    if (targetNode == nil) {
        targetNode = [self addNode:target withData:nil];
        targetNode.position = CGPointNearPoint(sourceNode.position, 1.0);
    }
    
    ATSpring *edge = [[ATSpring alloc] initWithSource:sourceNode target:targetNode userData:data];
    NSNumber *src = sourceNode.index;
    NSNumber *dst = targetNode.index;
    
    NSMutableDictionary *from = [self.state getAdjacencyObjectForKey:src];
    if (from == nil) {
        from = [NSMutableDictionary dictionaryWithCapacity:32];
        [self.state setAdjacencyObject:from forKey:src];
    }
    
    ATEdge *to = [from objectForKey:dst];
    if (to == nil) {
        
        [self.state setEdgesObject:edge forKey:edge.index];
        
        [from setObject:edge forKey:dst];
        
        [self addSpring:edge];
        
    } else {
        // probably shouldn't allow multiple edges in same direction
        // between same nodes? for now just overwriting the data...
        
        NSLog(@"Overwrote user data for an edge... Be sure this is what you wanted.");
        
        to.userData = data;
        return to;
    }
    
    return edge;
}

- (void) removeEdge:(ATEdge *)edge 
{    
    [self.state removeEdgesObjectForKey:edge.index];
    
    NSNumber *src = edge.source.index;
    NSNumber *dst = edge.target.index;
    
    NSMutableDictionary *from = [self.state getAdjacencyObjectForKey:src];
    
    if (from != nil) {
        [from removeObjectForKey:dst];
    }
    
    [self removeSpring:(ATSpring *)edge];  // Note: Upcast
}

- (NSSet *) getEdgesFromNode:(NSString *)source toNode:(NSString *)target 
{    
    ATNode *aNode1 = [self getNode:source];
    ATNode *aNode2 = [self getNode:target];
    
    if (aNode1 == nil || aNode2 == nil) return [NSSet set];
    
    NSNumber *src = aNode1.index;
    NSNumber *dst = aNode2.index;
    
    NSMutableDictionary *from = [self.state getAdjacencyObjectForKey:src];
    if (from == nil) {
        return [NSSet set];
    }
    
    ATEdge *to = [from objectForKey:dst];
    if (to == nil) {
        return [NSSet set];
    }
    
    return [NSSet setWithObject:to];
}

- (NSSet *) getEdgesFromNode:(NSString *)node 
{    
    ATNode *aNode = [self getNode:node];
    if (aNode == nil) return [NSSet set];
    
    NSNumber *src = aNode.index;
    
    NSMutableDictionary *from = [self.state getAdjacencyObjectForKey:src];
    if (from != nil) {
        return [NSSet setWithArray:[from allValues]];
    }
    
    return [NSSet set];
}

- (NSSet *) getEdgesToNode:(NSString *)node 
{    
    ATNode *aNode = [self getNode:node];
    if (aNode == nil) return [NSSet set];
    
    NSMutableSet *nodeEdges = [NSMutableSet set];
    for (ATEdge *edge in [self.state.edges allValues]) {
        if (edge.target == aNode) {
            [nodeEdges addObject:edge];
        }
    }
    
    return nodeEdges;
}


#pragma mark - Internal Interface

- (CGRect) ensureRect:(CGRect)rect minimumDimentions:(CGFloat)minimum
{
    // Ensure the view bounds rect has a minimum size
    CGFloat requiredOutsetX = 0.0;
    CGFloat requiredOutsetY = 0.0;
    
    if ( CGRectGetWidth(rect) < minimum ) {
        requiredOutsetX = (minimum - CGRectGetWidth(rect)) / 2.0;
    }
    
    if ( CGRectGetHeight(rect) < minimum) {
        requiredOutsetY = (minimum - CGRectGetHeight(rect)) / 2.0;
    }
    
    return CGRectInset(rect, -requiredOutsetX, -requiredOutsetY);
}

- (CGRect) tweenRect:(CGRect)sourceRect toRect:(CGRect)targetRect delta:(CGFloat)delta
{
    // Tween one rect to another based on delta: 0.0 == No change, 1.0 == Final State
    CGRect tweenRect = CGRectZero;
    
    CGPoint distanceTotal = CGPointSubtract(targetRect.origin, sourceRect.origin);
    CGPoint originMovement = CGPointMultiplyFloat(distanceTotal, delta);
    tweenRect.origin = CGPointAdd(sourceRect.origin, originMovement);
    
    
    CGSize steppedSize = CGSizeZero;
    
    steppedSize.width = sourceRect.size.width + ((targetRect.size.width - sourceRect.size.width) * delta);
    steppedSize.height = sourceRect.size.height + ((targetRect.size.height - sourceRect.size.height) * delta);
    tweenRect.size = steppedSize;
    
    return tweenRect;
}

- (BOOL) updateViewport
{
    // step the renderer's current bounding box closer to the true box containing all
    // the nodes. if _screenStep is set to 1 there will be no lag. if _screenStep is
    // set to 0 the bounding box will remain stationary after being initially set 
    
    // Return NO if we dont have a screen size.
    if ( CGRectIsEmpty(viewBounds_) ) {
        return NO;
    }
    
    // Ensure the view bounds rect has a minimum size
    tweenBoundsTarget_ = [self ensureRect:self.simulationBounds minimumDimentions:4.0];
    
    
    // Configure the current viewport bounds
    if ( CGRectIsEmpty(tweenBoundsCurrent_) ) {
        if ([self.state.nodes count] == 0) return NO;
        tweenBoundsCurrent_ = tweenBoundsTarget_;
        return YES;
    }
    
    // Move the current viewport bounds closer to the true box containing all the nodes.
    CGRect newBounds = [self tweenRect:tweenBoundsCurrent_ 
                                toRect:tweenBoundsTarget_ 
                                 delta:viewTweenStep_];
    
    
    // return true if we're still approaching the target, false if we're ‘close enough’
    CGFloat newX = tweenBoundsCurrent_.size.width - newBounds.size.width;
    CGFloat newY = tweenBoundsCurrent_.size.height - newBounds.size.height;
    CGPoint sizeDiff = CGPointMake(newX, newY);
    CGPoint diff = CGPointMake(CGPointMagnitude(CGPointSubtract(tweenBoundsCurrent_.origin, 
                                                                newBounds.origin)), 
                               CGPointMagnitude(sizeDiff));
    
    if (diff.x * viewBounds_.size.width > 1.0 || diff.y * viewBounds_.size.height > 1.0 ){
        tweenBoundsCurrent_ = newBounds;
        return YES;
    } else {
        return NO;        
    }
}


@end
