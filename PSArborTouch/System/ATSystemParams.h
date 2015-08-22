//
//  ATSystemParams.h
//  PSArborTouch
//
//  Created by Ed Preston on 30/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATSystemParams : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) CGFloat repulsion;
@property (nonatomic, assign) CGFloat stiffness;
@property (nonatomic, assign) CGFloat friction;
@property (nonatomic, assign) CGFloat deltaTime;
@property (nonatomic, assign) BOOL gravity;
@property (nonatomic, assign) CGFloat precision;
@property (nonatomic, assign) CGFloat timeout;

@end
