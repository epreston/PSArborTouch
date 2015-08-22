//
//  ATEnergy.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATEnergy : NSObject <NSCopying>

@property (nonatomic, assign) CGFloat sum;
@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) CGFloat mean;
@property (nonatomic, assign) NSUInteger count;

@end
