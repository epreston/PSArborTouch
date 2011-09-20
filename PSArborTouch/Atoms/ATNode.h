//
//  ATNode.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATNode : NSObject
{
    
@private
    NSString   *_name;
    CGFloat     _mass;
    CGPoint     _position;
    BOOL        _fixed;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat mass;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign, getter=isFixed) BOOL fixed;

- (id)init;
- (id)initWithName:(NSString *)name mass:(CGFloat)mass position:(CGPoint)position fixed:(BOOL)fixed;




@end
