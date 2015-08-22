//
//  ATSystem.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
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
- (CGRect) translationBounds;

@end


@implementation ATSystem

- (void) setParameters:(ATSystemParams *)parameters
{
    if (_parameters != parameters) {
        _parameters = [parameters copy];

    }
    
    [self updateSimulation:_parameters];
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        _state          = [[ATSystemState alloc] init];
        _parameters     = [[ATSystemParams alloc] init];
        _viewBounds     = CGRectZero;
        _viewPadding    = UIEdgeInsetsZero;
        _viewTweenStep  = 0.04;
        _viewMode       = ATViewConversionScale;
    }
    return self;
}

- (instancetype) initWithState:(ATSystemState *)state parameters:(ATSystemParams *)parameters
{
    self = [self init];
    if (self) {
        _state      = state;
        _parameters = parameters;
    }
    return self;
}


#pragma mark - Viewport Management / Translation


- (void) setViewBounds:(CGRect)viewBounds
{
    _viewBounds = viewBounds;
    [self updateViewport];
}


#pragma mark - Viewport Translation

- (CGRect) translationBounds {
    // Adjusting the translation bounds defines what coordinate system is being used
    // as the camera.
    
    return self.simulationBounds;
//    return tweenBoundsCurrent_;
//    return tweenBoundsTarget_;
}

- (CGRect) toViewRect:(CGRect)physicsRect
{
    CGRect ret;
    
    ret.origin  = [self toViewPoint:physicsRect.origin];
    ret.size    = [self toViewSize:physicsRect.size];
    
    return ret;
}

// TODO: Precalculate most of this
- (CGSize) toViewSize:(CGSize)physicsSize
{
    // Return the size in the physics coordinate system if we dont have a screen size or current
    // viewport bounds.
    if ( CGRectIsEmpty(_viewBounds) || CGRectIsEmpty(_tweenBoundsCurrent) ) {
        return physicsSize;
    }
    
    CGRect  fromBounds = [self translationBounds];
    
    // UIEdgeInsetsInsetRect
    CGFloat adjustedScreenWidth     = CGRectGetWidth(_viewBounds)  - (_viewPadding.left + _viewPadding.right);
    CGFloat adjustedScreenHeight    = CGRectGetHeight(_viewBounds) - (_viewPadding.top  + _viewPadding.bottom);
    
    
    CGFloat scaleX = physicsSize.width  / CGRectGetWidth(fromBounds);
    CGFloat scaleY = physicsSize.height / CGRectGetHeight(fromBounds);
    
    CGFloat sx  = 0.0;
    CGFloat sy  = 0.0;
    
    if (self.viewMode == ATViewConversionScale) {
        CGFloat uniformScale = MIN(adjustedScreenWidth, adjustedScreenHeight);
        
        sx  = (scaleX * uniformScale);
        sy  = (scaleY * uniformScale);
        
    } else { // Stretch
        
        sx  = (scaleX * adjustedScreenWidth );
        sy  = (scaleY * adjustedScreenHeight);
    }
    
    return CGSizeMake(sx, sy);
}

// TODO: InsetRect, precalculate
- (CGPoint) toViewPoint:(CGPoint)physicsPoint
{
    // Return the point in the physics coordinate system if we dont have a screen size or current
    // viewport bounds.
    if ( CGRectIsEmpty(_viewBounds) || CGRectIsEmpty(_tweenBoundsCurrent) ) {
        return physicsPoint;
    }
    
    CGRect  fromBounds = [self translationBounds];
    
    // UIEdgeInsetsInsetRect
    CGFloat adjustedScreenWidth     = CGRectGetWidth(_viewBounds)  - (_viewPadding.left + _viewPadding.right);
    CGFloat adjustedScreenHeight    = CGRectGetHeight(_viewBounds) - (_viewPadding.top  + _viewPadding.bottom);
    
    CGFloat scaleX = (physicsPoint.x - fromBounds.origin.x) / CGRectGetWidth(fromBounds);
    CGFloat scaleY = (physicsPoint.y - fromBounds.origin.y) / CGRectGetHeight(fromBounds);
    
    CGFloat sx  = 0.0;
    CGFloat sy  = 0.0;
    
    if (self.viewMode == ATViewConversionScale) {
        CGFloat uniformScale = MIN(adjustedScreenWidth, adjustedScreenHeight);
        
        sx = scaleX * uniformScale + _viewPadding.right;
        sy = scaleY * uniformScale + _viewPadding.top;
        
        // center
        sx += (adjustedScreenWidth  - uniformScale) / 2;
        sy += (adjustedScreenHeight - uniformScale) / 2;
        
    } else { // Stretch
        
        sx = scaleX * adjustedScreenWidth  + _viewPadding.right;
        sy = scaleY * adjustedScreenHeight + _viewPadding.top;
    }
    
    return CGPointMake(sx, sy);
}

// TODO: This is ugly
- (CGPoint) fromViewPoint:(CGPoint)viewPoint
{
    // Return the point in the screen coordinate system if we dont have a screen size.
    if ( CGRectIsEmpty(_viewBounds) || CGRectIsEmpty(_tweenBoundsCurrent) ) {
        return viewPoint;
    }
    
    CGRect  toBounds = [self translationBounds];
    
    // UIEdgeInsetsInsetRect
    CGFloat adjustedScreenWidth     = CGRectGetWidth(_viewBounds)  - (_viewPadding.left + _viewPadding.right);
    CGFloat adjustedScreenHeight    = CGRectGetHeight(_viewBounds) - (_viewPadding.top  + _viewPadding.bottom);
    
    CGFloat scaleX = (viewPoint.x - _viewPadding.right) / adjustedScreenWidth;
    CGFloat scaleY = (viewPoint.y - _viewPadding.top)   / adjustedScreenHeight;
    
    if (self.viewMode == ATViewConversionScale) {
        CGFloat uniformScale = MIN(adjustedScreenWidth, adjustedScreenHeight);
        
        scaleX = (viewPoint.x - ((adjustedScreenWidth  - uniformScale) / 2) - _viewPadding.right) / uniformScale;
        scaleY = (viewPoint.y - ((adjustedScreenHeight - uniformScale) / 2) - _viewPadding.top)   / uniformScale;
    }
        
    CGFloat px = scaleX * CGRectGetWidth(toBounds)  + toBounds.origin.x;
    CGFloat py = scaleY * CGRectGetHeight(toBounds) + toBounds.origin.y;
    
    return CGPointMake(px, py);
}

- (ATNode *) nearestNodeToPoint:(CGPoint)viewPoint 
{  
    // Find the nearest node to a particular position
    CGPoint translatedPoint = CGPointZero;
    
    // if view bounds has been specified, presume viewPoint is in screen pixel
    // units and convert it back to the physics engine coordinates
    if ( CGRectIsEmpty(_viewBounds) == NO ) {
        translatedPoint = [self fromViewPoint:viewPoint];
    } else {
        translatedPoint = viewPoint;
    }
    
    ATNode *closestNode         = nil;
    CGFloat closestDistance     = FLT_MAX;
    CGFloat distance            = 0.0;
    
    for (ATNode *node in self.state.nodes) {
        
        distance = CGPointDistance(node.position, translatedPoint);
        
        if (distance < closestDistance) {
            closestNode = node;
            closestDistance = distance;
        }
    }
    
    return closestNode;
}

- (ATNode *) nearestNodeToPoint:(CGPoint)viewPoint withinRadius:(CGFloat)viewRadius;
{
    NSParameterAssert(viewRadius > 0.0);    // Provide a viewRadius is the views coordinate system
                                            // or use nearestNodeToPoint instead.
    if (viewRadius <= 0.0) return nil;
    
    ATNode *closestNode = [self nearestNodeToPoint:viewPoint];
    if (closestNode) {
        // Find the nearest node to a particular position
        CGPoint translatedNodePoint = CGPointZero;
        
        // if view bounds has been specified, presume viewPoint is in screen pixel
        // units and convert the closest node to view space for comparison
        if ( CGRectIsEmpty(_viewBounds) == NO ) {
            translatedNodePoint = [self toViewPoint:closestNode.position];
        } else {
            translatedNodePoint = closestNode.position;
        }
        
        CGFloat distance = CGPointDistance(translatedNodePoint, viewPoint);
        if (distance > viewRadius) {
            closestNode = nil;
        }
    }
    
    return closestNode;
}


#pragma mark - Node Management

- (ATNode *) addNode:(NSString *)name withData:(NSMutableDictionary *)data 
{
    NSParameterAssert(name != nil);
    
    if (name == nil) return nil;    // name can not be nil, data can be nil
    
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
    NSParameterAssert(nodeName != nil);
    
    // remove a node and its associated edges from the graph
    ATNode *node = [self getNode:nodeName];
    if (node != nil) {
        
        [self.state removeNodesObjectForKey:node.index];
        [self.state removeNamesObjectForKey:node.name];
        
        for (ATEdge *edge in self.state.edges) {
            if (edge.source.index == node.index || edge.target.index == node.index) {
                [self removeEdge:edge];
            }
        }
        
        [self removeParticle:(ATParticle *)node];  // Note: Upcast
    }
}

- (ATNode *) getNode:(NSString *)nodeName 
{
    NSParameterAssert(nodeName != nil);
    
    if (nodeName == nil) return nil;
    return [self.state getNamesObjectForKey:nodeName];
}


#pragma mark - Edge Management

- (ATEdge *) addEdgeFromNode:(NSString *)source toNode:(NSString *)target withData:(NSMutableDictionary*)data 
{
    NSParameterAssert(source != nil);
    NSParameterAssert(target != nil);
    
    // source and target should not be nil, data can be nil
    if (source == nil || target == nil) return nil;
    
    ATNode *sourceNode = [self getNode:source];
    ATNode *targetNode = [self getNode:target];
    
    if (sourceNode == nil) {
        // Build the source node.
        sourceNode = [self addNode:source withData:nil];
        
        // If the target already exists, put the new source near it.
        if (targetNode != nil) {
            sourceNode.position = CGPointNearPoint(targetNode.position, 1.0);
        }
    }
    
    if (targetNode == nil) {
        // Build the target node
        targetNode = [self addNode:target withData:nil];
        
        if (sourceNode != nil) {
            // If we have to build the target node, create it close to the source node.
            targetNode.position = CGPointNearPoint(sourceNode.position, 1.0);
        }
    }
    
    // We cant create or search for the edge if we dont have both nodes.
    if (sourceNode == nil || targetNode == nil) return nil;
    
    NSNumber *src = sourceNode.index;
    NSNumber *dst = targetNode.index;
    
    // Search adjacency list
    NSMutableDictionary *from = [self.state getAdjacencyObjectForKey:src];
    if (from == nil) {
        // Expand the adjacency graph
        from = [NSMutableDictionary dictionaryWithCapacity:32];
        [self.state setAdjacencyObject:from forKey:src];
    }
    
    // Does the edge already exist?
    ATEdge *to = from[dst];
    if (to != nil) {
        // probably shouldn't allow multiple edges in same direction
        // between same nodes? for now just overwriting the data...
        
        NSLog(@"Overwrote user data for an edge... Be sure this is what you wanted.");
        
        to.userData = data;
        return to;
    }
    
    // Create the new edge
    ATSpring *edge = [[ATSpring alloc] initWithSource:sourceNode target:targetNode userData:data];
    
    // Store the edge
    [self.state setEdgesObject:edge forKey:edge.index];
    
    // Update the adjacency graph
    from[dst] = edge;
    
    // Add a new spring to represent the edge in the simulation
    [self addSpring:edge];
    
    return edge;
}

- (void) removeEdge:(ATEdge *)edge 
{    
    NSParameterAssert(edge != nil);
    
    if (edge == nil) return;
    
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
    NSParameterAssert(source != nil);
    NSParameterAssert(target != nil);
    
    // source and target should not be nil
    if (source == nil || target == nil) return [NSSet set];
    
    ATNode *aNode1 = [self getNode:source];
    ATNode *aNode2 = [self getNode:target];
    
    // We cant look up the edges without both nodes.
    if (aNode1 == nil || aNode2 == nil) return [NSSet set];
    
    NSNumber *src = aNode1.index;
    NSNumber *dst = aNode2.index;
    
    NSMutableDictionary *from = [self.state getAdjacencyObjectForKey:src];
    if (from == nil) {
        return [NSSet set];
    }
    
    ATEdge *to = from[dst];
    if (to == nil) {
        return [NSSet set];
    }
    
    return [NSSet setWithObject:to];
}

- (NSSet *) getEdgesFromNode:(NSString *)node 
{
    NSParameterAssert(node != nil);
    
    if (node == nil) return [NSSet set];
    
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
    NSParameterAssert(node != nil);
    
    if (node == nil) return [NSSet set];
    
    ATNode *aNode = [self getNode:node];
    if (aNode == nil) return [NSSet set];
    
    NSMutableSet *nodeEdges = [NSMutableSet set];
    for (ATEdge *edge in self.state.edges) {
        if (edge.target == aNode) {
            [nodeEdges addObject:edge];
        }
    }
    
    return nodeEdges;
}


#pragma mark - Internal Interface

- (CGRect) ensureRect:(CGRect)rect minimumDimentions:(CGFloat)minimum
{
    NSParameterAssert(minimum > 0.0);
    
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
    NSParameterAssert(delta <= 1.0);
    NSParameterAssert(delta >= 0.0);
    
    // Tween one rect to another based on delta: 0.0 == No change, 1.0 == Final State
    CGRect tweenRect = CGRectZero;
    
    CGPoint distanceTotal = CGPointSubtract(targetRect.origin, sourceRect.origin);
    CGPoint originMovement = CGPointScale(distanceTotal, delta);
    tweenRect.origin = CGPointAdd(sourceRect.origin, originMovement);
    
    
    CGSize steppedSize = CGSizeZero;
    
    steppedSize.width  = CGRectGetWidth(sourceRect)  + ((CGRectGetWidth(targetRect)  - CGRectGetWidth(sourceRect))  * delta);
    steppedSize.height = CGRectGetHeight(sourceRect) + ((CGRectGetHeight(targetRect) - CGRectGetHeight(sourceRect)) * delta);
    tweenRect.size = steppedSize;
    
    return tweenRect;
}

- (BOOL) updateViewport
{
    // step the renderer's current bounding box closer to the true box containing all
    // the nodes. if _screenStep is set to 1 there will be no lag. if _screenStep is
    // set to 0 the bounding box will remain stationary after being initially set 
    
    // Return NO if we dont have a screen size.
    if ( CGRectIsEmpty(_viewBounds) ) {
        return NO;
    }
    
    // Ensure the view bounds rect has a minimum size
    _tweenBoundsTarget = [self ensureRect:self.simulationBounds minimumDimentions:4.0];
    
    
    // Configure the current viewport bounds
    if ( CGRectIsEmpty(_tweenBoundsCurrent) ) {
        if ([self.state.nodes count] == 0) return NO;
        _tweenBoundsCurrent = _tweenBoundsTarget;
        return YES;
    }
    
    // If we are not tweening, then no need to calculate. Avoid endless viewport update.
    if (_viewTweenStep <= 0.0) return NO;
    
    // Move the current viewport bounds closer to the true box containing all the nodes.
    CGRect newBounds = [self tweenRect:_tweenBoundsCurrent 
                                toRect:_tweenBoundsTarget 
                                 delta:_viewTweenStep];
    
    
    // calculate the difference
    CGFloat newX = CGRectGetWidth(_tweenBoundsCurrent)  - CGRectGetWidth(newBounds);
    CGFloat newY = CGRectGetHeight(_tweenBoundsCurrent) - CGRectGetHeight(newBounds);
    CGPoint sizeDiff = CGPointMake(newX, newY);
    CGPoint diff = CGPointMake(CGPointDistance(_tweenBoundsCurrent.origin, newBounds.origin), 
                               CGPointMagnitude(sizeDiff));
    
    // return YES if we're still approaching the target, NO if we're ‘close enough’
    if (diff.x * CGRectGetWidth(_viewBounds) > 1.0 || diff.y * CGRectGetHeight(_viewBounds) > 1.0 ){
        _tweenBoundsCurrent = newBounds;
        return YES;
    } else {
        return NO;        
    }
}


@end
