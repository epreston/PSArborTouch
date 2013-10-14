//
//  ATBarnesHutBranch.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATBarnesHutBranch : NSObject
{
    
@private
    CGRect  bounds_;
    CGFloat mass_;
    CGPoint position_;
    
    id ne_;
    id nw_;
    id se_;
    id sw_;
}

@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) CGFloat mass;
@property (nonatomic, assign) CGPoint position;

@property (nonatomic, strong) id ne;
@property (nonatomic, strong) id nw;
@property (nonatomic, strong) id se;
@property (nonatomic, strong) id sw;

- (id) init;

- (id) initWithBounds:(CGRect)bounds 
                 mass:(CGFloat)mass 
             position:(CGPoint)position;

@end
