//
//  ATGeometry.h
//  PSArborTouch
//
//  Created by Ed Preston on 5/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//
//  general geometric functions for CGPoint's


#import <Foundation/Foundation.h>


#define ARC4RANDOM_MAX      0x100000000
#define RANDOM_0_1          ((CGFloat)arc4random()/(CGFloat)ARC4RANDOM_MAX)


static inline BOOL CGPointExploded(const CGPoint point)
{
    // Not safe for some math optimization flags
    return( isnan(point.x) || isnan(point.y) );
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    CGPoint r = { .x = a.x + b.x, .y = a.y + b.y };
    return(r);
}

static inline CGPoint CGPointSubtract(const CGPoint a, const CGPoint b)
{
    return(CGPointMake(a.x - b.x, a.y - b.y));
}

static inline CGPoint CGPointMultiply(const CGPoint a, const CGPoint b)
{
    CGPoint r = { .x = a.x * b.x, .y = a.y * b.y };
    return(r);
}

static inline CGPoint CGPointScale(const CGPoint point, const CGFloat scale)
{
    CGPoint r = { .x = point.x * scale, .y = point.y * scale };
    return(r);
}

static inline CGPoint CGPointDivideFloat(const CGPoint point, const CGFloat n)
{
    //    NSParameterAssert( n > 0);
    
    CGPoint r = { .x = point.x / n, .y = point.y / n };
    return(r);
}

static inline CGFloat CGPointDistance(const CGPoint start, const CGPoint finish)
{
    CGFloat xDelta = finish.x - start.x;
    CGFloat yDelta = finish.y - start.y;
    return sqrtf(xDelta * xDelta + yDelta * yDelta);
}

static inline CGFloat CGPointMagnitude(const CGPoint point)
{
    CGFloat m = sqrtf( (point.x * point.x) + (point.y * point.y) );
    return(m);
}

static inline CGPoint CGPointNormal(const CGPoint point)
{
    CGPoint r = { .x = point.x, .y = -point.y };
    return(r);
}

static inline CGPoint CGPointNormalize(const CGPoint point)
{    
    CGPoint r = CGPointDivideFloat(point, CGPointMagnitude(point));
    return(r);
}

static inline CGPoint CGPointRandom(const CGFloat radius)
{
    CGFloat targetRadius = (radius > 0.0) ? radius : 5.0;
    CGPoint r = { .x = 2 * targetRadius * (RANDOM_0_1 - 0.5), .y = 2 * targetRadius * (RANDOM_0_1 - 0.5) };
    return(r);
}

static inline CGPoint CGPointNearPoint(const CGPoint center_pt, const CGFloat radius)
{
    CGFloat targetRadius = (radius > 0.0) ? radius : 0.0;
    CGFloat x = center_pt.x;
    CGFloat y = center_pt.y;
    CGFloat d = targetRadius * 2;
    
    CGPoint r = { .x = x - targetRadius + RANDOM_0_1 * d, .y = y - targetRadius + RANDOM_0_1 * d};
    return(r);
}
