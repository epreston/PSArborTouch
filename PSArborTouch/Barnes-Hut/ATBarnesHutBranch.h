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

@property (nonatomic, retain) id ne;
@property (nonatomic, retain) id nw;
@property (nonatomic, retain) id se;
@property (nonatomic, retain) id sw;

- (id) init;

- (id) initWithBounds:(CGRect)bounds 
                 mass:(CGFloat)mass 
             position:(CGPoint)position;

@end
