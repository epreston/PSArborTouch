//
//  ATBarnesHutTree.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATBarnesHutTree.h"
#import "ATBarnesHutBranch.h"
#import "ATParticle.h"
#import "ATGeometry.h"


@interface ATBarnesHutTree ()
{
    
@private
    NSMutableArray     *_branches;
    NSUInteger          _branchCounter;
}

typedef NS_ENUM(NSInteger, BHLocation) {
    BHLocationUD = 0,
    BHLocationNW,
    BHLocationNE,
    BHLocationSE,
    BHLocationSW,
};

- (BHLocation) _whichQuad:(ATParticle *)particle ofBranch:(ATBarnesHutBranch *)branch;
- (void) _setQuad:(BHLocation)location ofBranch:(ATBarnesHutBranch *)branch withObject:(id)object;
- (id) _getQuad:(BHLocation)location ofBranch:(ATBarnesHutBranch *)branch;
- (ATBarnesHutBranch *) _dequeueBranch;

@end


@implementation ATBarnesHutTree

- (instancetype) init
{
    self = [super init];
    if (self) {
        _branches       = [NSMutableArray arrayWithCapacity:32];
        _branchCounter  = 0;
        _root           = nil;
        _bounds         = CGRectZero;
        _theta          = 0.4;
    }
    return self;
}



#pragma mark - Public Methods

- (void) updateWithBounds:(CGRect)bounds theta:(CGFloat)theta 
{
    _bounds         = bounds;
    _theta          = theta;
    
    _branchCounter  = 0;
    _root           = [self _dequeueBranch];
    _root.bounds    = bounds;
}

- (void) insertParticle:(ATParticle *)newParticle 
{
    NSParameterAssert(newParticle != nil);
    
    if (newParticle == nil) return;
    
    // add a particle to the tree, starting at the current _root and working down
    ATBarnesHutBranch *node = _root;
    
    NSMutableArray* queue = [NSMutableArray arrayWithCapacity:32];
        
    // Add particle to the end of the queue
    [queue addObject:newParticle];
    
    
    while ([queue count] != 0) {
        
        // dequeue
        ATParticle *particle = queue[0];
        [queue removeObjectAtIndex:0];
        
        CGFloat p_mass = particle.mass;
        BHLocation p_quad = [self _whichQuad:particle ofBranch:node];
        id objectAtQuad = [self _getQuad:p_quad ofBranch:node];
        
        
        if ( objectAtQuad == nil ) {
            
            // slot is empty, just drop this node in and update the mass/c.o.m. 
            node.mass += p_mass;
            node.position = CGPointAdd( node.position, CGPointScale(particle.position, p_mass) );
            
            [self _setQuad:p_quad ofBranch:node withObject:particle];
            
            // process next object in queue.
            continue;
        }
            
        if ( [objectAtQuad isKindOfClass:ATBarnesHutBranch.class] == YES ) {
            // slot conatins a branch node, keep iterating with the branch
            // as our new root
            
            node.mass += p_mass;
            node.position = CGPointAdd( node.position, CGPointScale(particle.position, p_mass) );
            
            node = objectAtQuad;
            
            // add the particle to the front of the queue
            [queue insertObject:particle atIndex:0];
            
            // process next object in queue.
            continue;
        }
        
        if ( [objectAtQuad isKindOfClass:ATParticle.class] == YES ) {

            // slot contains a particle, create a new branch and recurse with
            // both points in the queue now
            
            if ( CGRectGetHeight(node.bounds) == 0.0 || CGRectGetWidth(node.bounds) == 0.0 ) {
                NSLog(@"Should not be zero?");
            }
            
            CGSize branch_size;
            CGPoint branch_origin;
            

            // CHECK IF POINT IN RECT TO AVOID RECURSIVELY MAKING THE RECT INFINIATELY
            // SMALLER FOR SOME POINTS OUT OF BOUNDS.
            
            // CGRectContainsPoint
            
            branch_size = CGSizeMake( CGRectGetWidth(node.bounds) / 2.0, CGRectGetHeight(node.bounds) / 2.0);
            branch_origin = node.bounds.origin;
            
            
            // if (p_quad == BHLocationSE || p_quad == BHLocationSW) return;
            
            if (p_quad == BHLocationSE || p_quad == BHLocationSW) branch_origin.y += branch_size.height;
            if (p_quad == BHLocationSE || p_quad == BHLocationNE) branch_origin.x += branch_size.width;
            
            // replace the previously particle-occupied quad with a new internal branch node
            ATParticle *oldParticle = objectAtQuad;
            
            ATBarnesHutBranch *newBranch = [self _dequeueBranch];
            [self _setQuad:p_quad ofBranch:node withObject:newBranch];
            newBranch.bounds = CGRectMake(branch_origin.x, branch_origin.y, branch_size.width, branch_size.height);
            node.mass = p_mass;
            node.position = CGPointScale(particle.position, p_mass);
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
            
            // Add old particle to the end of the array
            [queue addObject:oldParticle];
            
            // Add new particle to the start of the array
            [queue insertObject:particle atIndex:0];
            
            
            // process next object in queue.
            continue;
        }
        
        NSLog(@"We should not make it here.");
        
    }
}

- (void) applyForces:(ATParticle *)particle andRepulsion:(CGFloat)repulsion 
{
    NSParameterAssert(particle != nil);
    
    if (particle == nil) return;
    
    // find all particles/branch nodes this particle interacts with and apply
    // the specified repulsion to the particle
    
    NSMutableArray* queue = [NSMutableArray arrayWithCapacity:32];
    [queue addObject:_root];
    
    while ([queue count] != 0) {
        
        // dequeue
        id node = queue[0];
        [queue removeObjectAtIndex:0];
        
        if (node == nil) continue;
        if (particle == node) continue;
        
        if ([node isKindOfClass:ATParticle.class] == YES) {
            // this is a particle leafnode, so just apply the force directly
            ATParticle *nodeParticle = node;
            
            CGPoint d = CGPointSubtract(particle.position, nodeParticle.position);
            CGFloat distance = MAX(1.0f, CGPointMagnitude(d));
            CGPoint direction = ( CGPointMagnitude(d) > 0.0 ) ? d : CGPointNormalize( CGPointRandom(1.0) );
            CGPoint force = CGPointDivideFloat( CGPointScale(direction, (repulsion * nodeParticle.mass) ), (distance * distance) );
            
            [particle applyForce:force];
            
        } else {
            // it's a branch node so decide if it's cluster-y and distant enough
            // to summarize as a single point. if it's too complex, open it and deal
            // with its quadrants in turn
            ATBarnesHutBranch *nodeBranch = node;
            
            CGFloat dist = CGPointMagnitude(CGPointSubtract(particle.position, CGPointDivideFloat(nodeBranch.position, nodeBranch.mass)));
            CGFloat size = sqrtf( CGRectGetWidth(nodeBranch.bounds) * CGRectGetHeight(nodeBranch.bounds) );
            
            if ( (size / dist) > _theta ) { // i.e., s/d > Θ
                // open the quad and recurse
                if (nodeBranch.ne != nil) [queue addObject:nodeBranch.ne];
                if (nodeBranch.nw != nil) [queue addObject:nodeBranch.nw];
                if (nodeBranch.se != nil) [queue addObject:nodeBranch.se];
                if (nodeBranch.sw != nil) [queue addObject:nodeBranch.sw];
            } else {
                // treat the quad as a single body
                CGPoint d = CGPointSubtract(particle.position, CGPointDivideFloat(nodeBranch.position, nodeBranch.mass));
                CGFloat distance = MAX(1.0, CGPointMagnitude(d));
                CGPoint direction = ( CGPointMagnitude(d) > 0.0 ) ? d : CGPointNormalize( CGPointRandom(1.0) );
                CGPoint force = CGPointDivideFloat( CGPointScale(direction, (repulsion * nodeBranch.mass) ), (distance * distance) );
                
                [particle applyForce:force];
            }
        }
    }
}


#pragma mark - Internal Interface

// TODO: Review - should these next 3 just be branch members ?

- (BHLocation) _whichQuad:(ATParticle *)particle ofBranch:(ATBarnesHutBranch *)branch 
{
    NSParameterAssert(particle != nil);
    NSParameterAssert(branch != nil);
    
    // sort the particle into one of the quadrants of this node
    if ( CGPointExploded(particle.position) ) {
        return BHLocationUD;
    }
    
    CGPoint particle_p = CGPointSubtract(particle.position, branch.bounds.origin);
    CGSize halfsize = CGSizeMake(CGRectGetWidth(branch.bounds)  / 2.0, 
                                 CGRectGetHeight(branch.bounds) / 2.0);
    
    if ( particle_p.y < halfsize.height ) {
        if ( particle_p.x < halfsize.width ) return BHLocationNW;
        else return BHLocationNE;
    } else {
        if ( particle_p.x < halfsize.width) return BHLocationSW;
        else return BHLocationSE;
    }
}

- (void) _setQuad:(BHLocation)location ofBranch:(ATBarnesHutBranch *)branch withObject:(id)object
{
    NSParameterAssert(branch != nil);
    
    switch (location) {
            
        case BHLocationNE:
            branch.ne = object;
            break;
            
        case BHLocationSE:
            branch.se = object;
            break;
            
        case BHLocationSW:
            branch.sw = object;
            break;
            
        case BHLocationNW:
            branch.nw = object;
            break;
            
        case BHLocationUD:
        default:
            NSLog(@"Could not set quad for node!");
            break;
    }
}

- (id) _getQuad:(BHLocation)location ofBranch:(ATBarnesHutBranch *)branch 
{
    NSParameterAssert(branch != nil);
    
    switch (location) {
            
        case BHLocationNE:
            return branch.ne;
            break;
            
        case BHLocationSE:
            return branch.se;
            break;
            
        case BHLocationSW:
            return branch.sw;
            break;
            
        case BHLocationNW:
            return branch.nw;
            break;
            
        case BHLocationUD:
        default:
            NSLog(@"Could not get quad for node!");
            return nil;
            break;
    }
}

- (ATBarnesHutBranch *) _dequeueBranch 
{    
    // Recycle the tree nodes between iterations, nodes are owned by the branches array
    ATBarnesHutBranch *branch = nil;
    
    if ( _branches.count == 0 || _branchCounter > (_branches.count -1) ) {
        branch = [[ATBarnesHutBranch alloc] init];
        [_branches addObject:branch];
    } else {
        branch = _branches[_branchCounter];
        branch.ne = nil;
        branch.nw = nil;
        branch.se = nil;
        branch.sw = nil;
        branch.bounds = CGRectZero;
        branch.mass = 0.0;
        branch.position = CGPointZero;
    }
    
//    NSLog(@"Branch count:%u", _branches.count);
    
    _branchCounter++;

    // DEBUG for a graph of 4 nodes
//    if (branchCounter_ > 6) {
//        NSLog(@"Somethings going wrong here.");
//    }
    

    return branch;
}


@end
