//
//  ATSystem.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ATKernel.h"


typedef NS_ENUM(NSInteger, ATViewConversion) {
    ATViewConversionStretch = 0,    // stretch the simulation coordinates to match view aspect
    ATViewConversionScale,          // scale the simluation coordinates to best fit view
};


@class ATSystemState;
@class ATSystemParams;
@class ATNode;
@class ATEdge;

@interface ATSystem : ATKernel


#pragma mark - Tween Debugging

@property (nonatomic, readonly, assign) CGRect tweenBoundsCurrent;
@property (nonatomic, readonly, assign) CGRect tweenBoundsTarget;


#pragma mark - System State Management

@property (nonatomic, strong) ATSystemState *state;

// Changes to your copy do not take effect on the system until you pass them back
@property (nonatomic, copy) ATSystemParams *parameters;

- (instancetype) initWithState:(ATSystemState *)state
                    parameters:(ATSystemParams *)parameters;


#pragma mark - Viewport Management

@property (nonatomic, assign) CGRect viewBounds;
@property (nonatomic, assign) UIEdgeInsets viewPadding;
@property (nonatomic, assign) CGFloat viewTweenStep;
@property (nonatomic, assign) ATViewConversion viewMode;

#pragma mark - Viewport Translation

- (CGRect) toViewRect:(CGRect)physicsRect;
- (CGSize) toViewSize:(CGSize)physicsSize;

- (CGPoint) toViewPoint:(CGPoint)physicsPoint;
- (CGPoint) fromViewPoint:(CGPoint)viewPoint;

- (ATNode *) nearestNodeToPoint:(CGPoint)viewPoint;
- (ATNode *) nearestNodeToPoint:(CGPoint)viewPoint withinRadius:(CGFloat)viewRadius;

#pragma mark - Node Management

- (ATNode *) getNode:(NSString *)nodeName;
- (ATNode *) addNode:(NSString *)name withData:(NSMutableDictionary *)data;
- (void) removeNode:(NSString *)nodeName;

#pragma mark - Edge Management

- (ATEdge *) addEdgeFromNode:(NSString *)source toNode:(NSString *)target withData:(NSMutableDictionary *)data;
- (void) removeEdge:(ATEdge *)edge;
- (NSSet *) getEdgesFromNode:(NSString *)source toNode:(NSString *)target;
- (NSSet *) getEdgesFromNode:(NSString *)node;
- (NSSet *) getEdgesToNode:(NSString *)node;

// Graft ?
// Merge ?

@end
