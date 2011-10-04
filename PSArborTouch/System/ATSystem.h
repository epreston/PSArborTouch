//
//  ATSystem.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ATKernel.h"

@class ATSystemState;
@class ATSystemParams;
@class ATNode;
@class ATEdge;

@interface ATSystem : ATKernel
{
    
@private
    CGRect          viewBounds_;
    UIEdgeInsets    viewPadding_;
    
    CGFloat         viewTweenStep_;
    CGRect          tweenBoundsCurrent_;
    CGRect          tweenBoundsTarget_;
    
    ATSystemState   *state_;
    ATSystemParams  *parameters_;
}

#pragma mark - Tween Debugging

@property (nonatomic, readonly, assign) CGRect tweenBoundsCurrent;
@property (nonatomic, readonly, assign) CGRect tweenBoundsTarget;


#pragma mark - System State Management

@property (nonatomic, retain) ATSystemState *state;

// Changes to your copy do not take effect on the system until you pass them back
@property (nonatomic, copy) ATSystemParams *parameters;

- (id)init;
- (id)initWithState:(ATSystemState *)state parameters:(ATSystemParams *)parameters;


#pragma mark - Viewport Management / Translation

@property (nonatomic, assign) CGRect viewBounds;
@property (nonatomic, assign) UIEdgeInsets viewPadding;
@property (nonatomic, assign) CGFloat viewTweenStep;

- (CGSize) toViewSize:(CGSize)physicsSize;
- (CGPoint) toViewPoint:(CGPoint)physicsPoint;
- (CGPoint) fromViewPoint:(CGPoint)viewPoint;
- (ATNode *) nearestNodeToPoint:(CGPoint)viewPoint;
- (ATNode *) nearestNodeToPoint:(CGPoint)viewPoint withinRadius:(CGFloat)viewRadius;

#pragma mark - Node Management

- (ATNode *) addNode:(NSString *)name withData:(NSMutableDictionary *)data;
- (void) removeNode:(NSString *)nodeName;
- (ATNode *) getNode:(NSString *)nodeName;


#pragma mark - Edge Management

- (ATEdge *) addEdgeFromNode:(NSString *)source toNode:(NSString *)target withData:(NSMutableDictionary *)data;
- (void) removeEdge:(ATEdge *)edge;
- (NSSet *) getEdgesFromNode:(NSString *)source toNode:(NSString *)target;
- (NSSet *) getEdgesFromNode:(NSString *)node;
- (NSSet *) getEdgesToNode:(NSString *)node;

// Graft ?
// Merge ?

@end
