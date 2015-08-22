//
//  ATNode.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATNode : NSObject <NSCoding>

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, assign) CGFloat mass;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign, getter=isFixed) BOOL fixed;

@property (nonatomic, readonly, strong) NSNumber *index;

@property (nonatomic, strong) NSMutableDictionary *userData;

- (instancetype) initWithName:(NSString *)name
                         mass:(CGFloat)mass
                     position:(CGPoint)position
                        fixed:(BOOL)fixed;

- (instancetype) initWithName:(NSString *)name
                     userData:(NSMutableDictionary *)data;

@end
