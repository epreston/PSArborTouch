//
//  ATSystemEnergy.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATSystemEnergy : NSObject
{
    CGFloat _sum;
    CGFloat _max;
    CGFloat _mean;
    CGFloat _count;
}

@property (nonatomic, assign) CGFloat sum;
@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) CGFloat mean;
@property (nonatomic, assign) CGFloat count;

- (id)init;

@end
