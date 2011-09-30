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
    NSMutableArray     *branches_;
    NSUInteger          branchCounter_;
    
    ATBarnesHutBranch  *root_;
    CGRect              bounds_;
    CGFloat             theta_;
}

@property (nonatomic, readonly, retain) ATBarnesHutBranch *root;
@property (nonatomic, readonly, assign) CGRect bounds;
@property (nonatomic, readonly, assign) CGFloat theta;

- (id) init;

- (void) updateWithBounds:(CGRect)bounds theta:(CGFloat)theta;
- (void) insertParticle:(ATParticle *)newParticle;
- (void) applyForces:(ATParticle *)particle andRepulsion:(CGFloat)repulsion;

@end
