//
//  ATSystem.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ATKernel.h"

@interface ATSystem : ATKernel
{
    
@private
    
    UIEdgeInsets    _screenPadding;
    CGFloat         _screenStep;
    CGRect          _screenBounds;
    
    CGRect          _viewBoundsCurrent;
    CGRect          _viewBoundsTarget;
}


@property (nonatomic, assign) CGFloat fps;


- (CGPoint) toScreen:(CGPoint)physicsPoint;
- (CGPoint) fromScreen:(CGPoint)screenPoint;

@end
