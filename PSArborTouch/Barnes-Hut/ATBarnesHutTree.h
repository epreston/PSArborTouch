//
//  ATBarnesHutTree.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ATBarnesHutBranch;
@class ATParticle;


@interface ATBarnesHutTree : NSObject
{
    
@private
    NSMutableArray     *_branches;
    NSUInteger          _branchCtr;
    ATBarnesHutBranch  *_root;
    
    CGRect              _bounds;
    CGFloat             _theta;
}

@property (nonatomic, retain) NSMutableArray *branches;
@property (nonatomic, assign) NSUInteger branchCtr;
@property (nonatomic, retain) ATBarnesHutBranch *root;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) CGFloat theta;
- (id) init;


- (void) updateWithBounds:(CGRect)bounds theta:(CGFloat)theta;
- (void) insertParticle:(ATParticle *)newParticle;
- (void) applyForces:(ATParticle *)particle andRepulsion:(CGFloat)repulsion;

@end
