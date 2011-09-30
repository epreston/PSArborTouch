//
//  ATSystem.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATSystem.h"

#import "ATGeometry.h"

@interface ATSystem ()

// private interface for ATSystem
- (BOOL) _updateBounds;

- (CGRect) ensureRect:(CGRect)rect minimumDimentions:(CGFloat)minimum;

@end


@implementation ATSystem

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (CGFloat) fps
{
    return 0.0;
}


- (void) setFps:(CGFloat)fps
{
    // 
}



- (CGPoint) toScreen:(CGPoint)physicsPoint
{
    // Return the point in the physics coordinate system if we dont have a screen size or current
    // viewport bounds.
    if ( CGRectIsEmpty(_screenBounds) || CGRectIsEmpty(_viewBoundsCurrent) ) {
        return physicsPoint;
    }
    
//    CGRect  fromBounds = self.simulationBounds;
    CGRect  fromBounds = _viewBoundsCurrent;
    
    
    CGFloat adjustedScreenWidth     = _screenBounds.size.width  - (_screenPadding.left + _screenPadding.right);
    CGFloat adjustedScreenHeight    = _screenBounds.size.height - (_screenPadding.top  + _screenPadding.bottom);
    
    CGFloat scaleX = (physicsPoint.x - fromBounds.origin.x) / fromBounds.size.width;
    CGFloat scaleY = (physicsPoint.y - fromBounds.origin.y) / fromBounds.size.height;
    
    CGFloat sx = scaleX * adjustedScreenWidth  + _screenPadding.right;
    CGFloat sy = scaleY * adjustedScreenHeight + _screenPadding.top;

    return CGPointMake(sx, sy);
}

- (CGPoint) fromScreen:(CGPoint)screenPoint
{
    // Return the point in the screen coordinate system if we dont have a screen size.
    if ( CGRectIsEmpty(_screenBounds) || CGRectIsEmpty(_viewBoundsCurrent) ) {
        return screenPoint;
    }
    
//    CGRect  toBounds = self.simulationBounds;
    CGRect  toBounds = _viewBoundsCurrent;
    
    CGFloat adjustedScreenWidth     = _screenBounds.size.width  - (_screenPadding.left + _screenPadding.right);
    CGFloat adjustedScreenHeight    = _screenBounds.size.height - (_screenPadding.top  + _screenPadding.bottom);
    
    CGFloat scaleX = (screenPoint.x - _screenPadding.right) / adjustedScreenWidth;
    CGFloat scaleY = (screenPoint.y - _screenPadding.top)   / adjustedScreenHeight;
    
    CGFloat px = scaleX * toBounds.size.width  + toBounds.origin.x;
    CGFloat py = scaleY * toBounds.size.height + toBounds.origin.y;

    return CGPointMake(px, py);
}


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

- (BOOL) _updateBounds
{
    // step the renderer's current bounding box closer to the true box containing all
    // the nodes. if _screenStep is set to 1 there will be no lag. if _screenStep is
    // set to 0 the bounding box will remain stationary after being initially set 
    
    
    // Return NO if we dont have a screen size.
    if ( CGRectIsEmpty(_screenBounds) ) {
        return NO;
    }
    
    // Ensure the view bounds rect has a minimum size
    _viewBoundsTarget = [self ensureRect:self.simulationBounds minimumDimentions:4.0];
    
    
    
    
    // Configure the current viewport bounds
    if ( CGRectIsEmpty(_viewBoundsCurrent) ) {
//        if ($.isEmptyObject(state.nodes)) return NO;
        _viewBoundsCurrent = _viewBoundsTarget;
        return YES;
    }
    

    
    // Move the current viewport bounds closer to the true box containing all the nodes.
    
    CGFloat stepSize = _screenStep;
    CGRect _newBounds = CGRectZero;
    
    
    CGPoint originMovement = CGPointMultiplyFloat(CGPointSubtract(_viewBoundsTarget.origin, 
                                                                   _viewBoundsCurrent.origin),  
                                                  stepSize);
    
    _newBounds.origin = CGPointAdd(_viewBoundsCurrent.origin, originMovement);
    
    
    CGSize steppedSize = CGSizeZero;
    
    steppedSize.width = (_viewBoundsCurrent.size.width + (_viewBoundsTarget.size.width - _viewBoundsCurrent.size.width)) * stepSize;
    
    steppedSize.height = (_viewBoundsCurrent.size.height + (_viewBoundsTarget.size.height - _viewBoundsCurrent.size.height)) * stepSize;
    
    _newBounds.size = steppedSize;

    
    
    
    // return true if we're still approaching the target, false if we're ‘close enough’
    
    CGFloat newX = (_viewBoundsCurrent.origin.x + _viewBoundsCurrent.size.width) - _newBounds.origin.x;
    CGFloat newY = (_viewBoundsCurrent.origin.y + _viewBoundsCurrent.size.height) - _newBounds.origin.y;
    
    CGPoint bottomRight = CGPointMake(newX, newY);
    
    CGPoint diff = CGPointMake(magnitude( CGPointSubtract(_viewBoundsCurrent.origin, _newBounds.origin)),
                             magnitude(bottomRight));
    
    if (diff.x * _screenBounds.size.width > 1.0 || diff.y * _screenBounds.size.height > 1.0 ){
        _viewBoundsCurrent = _newBounds;
        return YES;
    }else{
        return NO;        
    }
}

@end
