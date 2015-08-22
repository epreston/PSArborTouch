//
//  ATBarnesHutTree.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATBarnesHutBranch;
@class ATParticle;

@interface ATBarnesHutTree : NSObject

@property (nonatomic, readonly, strong) ATBarnesHutBranch *root;
@property (nonatomic, readonly, assign) CGRect bounds;
@property (nonatomic, readonly, assign) CGFloat theta;

- (void) updateWithBounds:(CGRect)bounds theta:(CGFloat)theta;
- (void) insertParticle:(ATParticle *)newParticle;
- (void) applyForces:(ATParticle *)particle andRepulsion:(CGFloat)repulsion;

@end
