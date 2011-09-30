//
//  ATBarnesHutTree.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATBarnesHutTree.h"
#import "ATBarnesHutBranch.h"
#import "ATParticle.h"
#import "ATGeometry.h"

#import "NSMutableArray+QueueAdditions.h"


@interface ATBarnesHutTree ()

typedef enum {
    BHLocationUD = 0,
    BHLocationNW,
    BHLocationNE,
    BHLocationSE,
    BHLocationSW,
} BHLocation;

- (BHLocation) _whichQuad:(ATParticle *)particle andNode:(ATBarnesHutBranch *)node;
- (void) _setQuad:(BHLocation)location andNode:(ATBarnesHutBranch *)node andObject:(id)object;
- (id) _getQuad:(BHLocation)location andNode:(ATBarnesHutBranch *)node;
- (ATBarnesHutBranch *) _newBranch;

@end



@implementation ATBarnesHutTree

@synthesize branches = _branches;
@synthesize branchCtr = _branchCtr;
@synthesize root = _root;
@synthesize bounds = _bounds;
@synthesize theta = _theta;


- (id) init
{
    self = [super init];
    if (self) {
        _branches = [[NSMutableArray arrayWithCapacity:32] retain];
        _branchCtr = 0;
        _root = nil;
        _bounds = CGRectZero;
        _theta = 0.4;
    }
    return self;
}

- (void) dealloc
{
    [_branches release];
    [_root release];
    
    [super dealloc];
}


#pragma mark - Public Methods

- (void) updateWithBounds:(CGRect)bounds theta:(CGFloat)theta 
{
    self.theta = theta;
    self.bounds = bounds;
    self.branchCtr = 0;
    self.root = [self _newBranch];
    self.root.bounds = bounds;
}


// TODO: Defensive programming !! 


- (void) insertParticle:(ATParticle *)newParticle 
{
    NSParameterAssert(newParticle != nil);
    
    // add a particle to the tree, starting at the current _root and working down
    ATBarnesHutBranch *node = _root;
    
    NSMutableArray* queue = [NSMutableArray arrayWithCapacity:32];
    [queue enqueue:newParticle];
    
    while ([queue count] != 0) {
        ATParticle *particle = [queue dequeue];
        CGFloat p_mass = particle.mass;
        BHLocation p_quad = [self _whichQuad:particle andNode:node];
        id objectAtQuad = [self _getQuad:p_quad andNode:node];
        
        
        if ( objectAtQuad == nil ) {
            
            // slot is empty, just drop this node in and update the mass/c.o.m. 
            [self _setQuad:p_quad andNode:node andObject:particle];
            
            node.mass += p_mass;
            node.position = CGPointAdd( node.position, CGPointMultiplyFloat(particle.position, p_mass) );
            
            // process next object in queue.
            continue;
        }
            
        if ( [objectAtQuad isKindOfClass:ATBarnesHutBranch.class] == YES ) {
            // slot conatins a branch node, keep iterating with the branch
            // as our new root
            
            node.mass += p_mass;
            node.position = CGPointAdd( node.position, CGPointMultiplyFloat(particle.position, p_mass) );
            
            node = objectAtQuad;
            [queue insertObject:particle atIndex:0];
            
            // process next object in queue.
            continue;
        }
        
        if ( [objectAtQuad isKindOfClass:ATParticle.class] == YES ) {

            // slot contains a particle, create a new branch and recurse with
            // both points in the queue now
            
            if ( node.bounds.size.height == 0.0  || node.bounds.size.width == 0.0 ) {
                NSLog(@"Should not be zero?");
            }
            
            CGSize branch_size;
            CGPoint branch_origin;
            

            
            // CHECK IF POINT IN RECT TO AVOID RECURSIVELY MAKING THE RECT INFINIATELY
            // SMALLER FOR SOME POINTS OUT OF BOUNDS.
            
            // CGRectContainsPoint
            
            branch_size = CGSizeMake(node.bounds.size.width / 2.0, node.bounds.size.height / 2.0);
            branch_origin = node.bounds.origin;
            
            
            // if (p_quad == BHLocationSE || p_quad == BHLocationSW) return;
            
            if (p_quad == BHLocationSE || p_quad == BHLocationSW) branch_origin.y += branch_size.height;
            if (p_quad == BHLocationSE || p_quad == BHLocationNE) branch_origin.x += branch_size.width;
            
            // replace the previously particle-occupied quad with a new internal branch node
            ATParticle *oldParticle = objectAtQuad;
            
            ATBarnesHutBranch *newBranch = [self _newBranch];
            [self _setQuad:p_quad andNode:node andObject:newBranch];
            newBranch.bounds = CGRectMake(branch_origin.x, branch_origin.y, branch_size.width, branch_size.height);
            node.mass = p_mass;
            node.position = CGPointMultiplyFloat(particle.position, p_mass);
            node = newBranch;
            
            if ( (oldParticle.position.x == particle.position.x) && (oldParticle.position.y == particle.position.y) ) {
                // prevent infinite bisection in the case where two particles
                // have identical coordinates by jostling one of them slightly
                
                CGFloat x_spread = branch_size.width * 0.08;
                CGFloat y_spread = branch_size.height * 0.08;
                
                CGPoint newPos = CGPointZero;
                
                newPos.x = MIN(branch_origin.x + branch_size.width, 
                               MAX(branch_origin.x, 
                                   oldParticle.position.x - x_spread/2 + 
                                   RANDOM_0_1 * x_spread));
                
                newPos.y = MIN(branch_origin.y + branch_size.height,  
                               MAX(branch_origin.y,  
                                   oldParticle.position.y - y_spread/2 + 
                                   RANDOM_0_1 * y_spread));
                
                oldParticle.position = newPos;
            }
            
            // keep iterating but now having to place both the current particle and the
            // one we just replaced with the branch node
            [queue enqueue:oldParticle];
            [queue insertObject:particle atIndex:0];
            
            
            // process next object in queue.
            continue;
        }
        
        NSLog(@"We should not make it here.");
        
    }
}

- (void) applyForces:(ATParticle *)particle andRepulsion:(CGFloat)repulsion 
{    
    // find all particles/branch nodes this particle interacts with and apply
    // the specified repulsion to the particle
    
    NSMutableArray* queue = [NSMutableArray arrayWithCapacity:32];
    [queue addObject:_root];
    
    while ([queue count] != 0) {
        id node = [queue dequeue];
        if (node == nil) continue;
        if (particle == node) continue;
        
        if ([node isKindOfClass:ATParticle.class] == YES) {
            // this is a particle leafnode, so just apply the force directly
            ATParticle *nodeParticle = node;
            
            CGPoint d = CGPointSubtract(particle.position, nodeParticle.position);
            CGFloat distance = MAX(1.0f, magnitude(d));
            CGPoint direction = ( magnitude(d) > 0.0 ) ? d : CGPointNormalize( CGPointRandom(1.0) );
            CGPoint force = CGPointDivideFloat( CGPointMultiplyFloat(direction, (repulsion * nodeParticle.mass) ), (distance * distance) );
            
            [particle applyForce:force];
            
        } else {
            // it's a branch node so decide if it's cluster-y and distant enough
            // to summarize as a single point. if it's too complex, open it and deal
            // with its quadrants in turn
            ATBarnesHutBranch *nodeBranch = node;
            
            CGFloat dist = magnitude(CGPointSubtract(particle.position, CGPointDivideFloat(nodeBranch.position, nodeBranch.mass)));
            CGFloat size = sqrtf(nodeBranch.bounds.size.width * nodeBranch.bounds.size.height);
            
            if ( (size / dist) > _theta ) { // i.e., s/d > Θ
                // open the quad and recurse
                [queue enqueue:nodeBranch.ne];
                [queue enqueue:nodeBranch.nw];
                [queue enqueue:nodeBranch.se];
                [queue enqueue:nodeBranch.sw];
            } else {
                // treat the quad as a single body
                CGPoint d = CGPointSubtract(particle.position, CGPointDivideFloat(nodeBranch.position, nodeBranch.mass));
                CGFloat distance = MAX(1.0, magnitude(d));
                CGPoint direction = ( magnitude(d) > 0.0 ) ? d : CGPointNormalize( CGPointRandom(1.0) );
                CGPoint force = CGPointDivideFloat( CGPointMultiplyFloat(direction, (repulsion * nodeBranch.mass) ), (distance * distance) );
                
                [particle applyForce:force];
            }
        }
    }
}


#pragma mark - Private Methods

// TODO: Review - should these next 3 just be branch members ?

- (BHLocation) _whichQuad:(ATParticle *)particle andNode:(ATBarnesHutBranch *)node 
{    
    // sort the particle into one of the quadrants of this node
    if ( CGPointExploded(particle.position) ) {
        return BHLocationUD;
    }
    
    CGPoint particle_p = CGPointSubtract(particle.position, node.bounds.origin);
    CGSize halfsize = CGSizeMake(node.bounds.size.width / 2.0, 
                                  node.bounds.size.height / 2.0);
    
    if ( particle_p.y < halfsize.height ) {
        if ( particle_p.x < halfsize.width ) return BHLocationNW;
        else return BHLocationNE;
    } else {
        if ( particle_p.x < halfsize.width) return BHLocationSW;
        else return BHLocationSE;
    }
}

- (void) _setQuad:(BHLocation)location andNode:(ATBarnesHutBranch *)node andObject:(id)object
{
    switch (location) {
            
        case BHLocationNE:
            node.ne = object;
            break;
            
        case BHLocationSE:
            node.se = object;
            break;
            
        case BHLocationSW:
            node.sw = object;
            break;
            
        case BHLocationNW:
            node.nw = object;
            break;
            
        default:
            break;
    }
}

- (id) _getQuad:(BHLocation)location andNode:(ATBarnesHutBranch *)node 
{    
    switch (location) {
            
        case BHLocationNE:
            return node.ne;
            break;
            
        case BHLocationSE:
            return node.se;
            break;
            
        case BHLocationSW:
            return node.sw;
            break;
            
        case BHLocationNW:
            return node.nw;
            break;
            
        default:
            return nil;
            break;
    }
}

- (ATBarnesHutBranch *) _newBranch 
{    
    // Recycle the tree nodes between iterations, nodes are owned by the branches array
    ATBarnesHutBranch *branch = nil;
    
    if ( _branches.count == 0 || _branchCtr > (_branches.count -1) ) {
        branch = [[ATBarnesHutBranch alloc] init];
        [_branches addObject:branch];
    } else {
        branch = [_branches objectAtIndex:_branchCtr];
        branch.ne = nil;
        branch.nw = nil;
        branch.se = nil;
        branch.sw = nil;
        branch.bounds = CGRectZero;
        branch.mass = 0.0;
        branch.position = CGPointZero;
    }
    
//    NSLog(@"Branch count:%u", _branches.count);
    
    _branchCtr++;
    
    if (_branchCtr > 6) {
        NSLog(@"Somethings going wrong here.");
    }
    return branch;
}


@end
