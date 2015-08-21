//
//  SystemRigViewController.m
//  SystemRig - System Test / Debug Rig
//
//  Created by Ed Preston on 26/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "SystemRigViewController.h"

#import "ATSystemDebugView.h"
#import "ATSystem.h"
#import "ATPhysics.h"
#import "ATNode.h"


@interface SystemRigViewController ()
{
    
@private
    ATSystem *_system;
}

@end

@implementation SystemRigViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _system = [[ATSystem alloc] init];
    
    _system.viewBounds = self.view.bounds;
    _system.viewPadding = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
    _system.delegate = self;
//    system.physics.theta = 0.0;
    
    self.debugView.system = _system;
    self.debugView.debugDrawing = YES;
    
    // add some nodes to the graph and watch it go...
    [_system addEdgeFromNode:@"a" toNode:@"b" withData:nil];
    [_system addEdgeFromNode:@"a" toNode:@"c" withData:nil];
    [_system addEdgeFromNode:@"a" toNode:@"d" withData:nil];
    [_system addEdgeFromNode:@"a" toNode:@"e" withData:nil];
    
//    [system addEdge:@"e" toTarget:@"f" andData:nil];
//    [system addEdge:@"e" toTarget:@"g" andData:nil];
//    [system addEdge:@"e" toTarget:@"h" andData:nil];
//    
//    [system addEdge:@"h" toTarget:@"j" andData:nil];
//    [system addEdge:@"h" toTarget:@"k" andData:nil];
//    [system addEdge:@"h" toTarget:@"l" andData:nil];
    
    
//    [system addEdge:@"x" toTarget:@"y" andData:nil];
//    [system addEdge:@"y" toTarget:@"z" andData:nil];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [self.debugView addGestureRecognizer:panGesture];
}

- (void)viewDidUnload
{
    [self setDebugView:nil];
    [super viewDidUnload];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for landscape orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark - Interface Actions

- (IBAction)go:(id)sender
{
    [_system start:YES];
}

- (IBAction)add:(id)sender
{
    [_system addEdgeFromNode:@"a" toNode:@"e" withData:nil];
    
    [self go:nil];
}

- (IBAction)remove:(id)sender
{
    [_system removeNode:@"e"];
    
    [self go:nil];
}

#pragma mark - Touch Handling 

- (CGPoint) fromScreen:(CGPoint)p 
{
    CGSize size = self.debugView.bounds.size;
    CGFloat midX = size.width / 2;
    CGFloat midY = size.height / 2;
    
    CGFloat scaleX = size.width / 20;
    CGFloat scaleY = size.height / 20;
    
    CGFloat sx  = (p.x - midX) / scaleX;
    CGFloat sy  = (p.y - midY) / scaleY ;
    
    return CGPointMake(sx, sy);
}


// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
- (void) panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    
    //[self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
//        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        CGPoint translation = [gestureRecognizer translationInView:piece];
        
        ATNode *node = [_system nearestNodeToPoint:translation withinRadius:500.0];
        
//        translation = [self fromScreen:translation];
        
        if (node) {
            node.position = CGPointMake(node.position.x + translation.x, node.position.y + translation.y);
            
            [_system start:YES];
        }
        
//        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        
        [gestureRecognizer setTranslation:CGPointZero inView:piece]; 
    }
    
    
}

#pragma mark - ATDebugRendering Protocol

- (void) redraw
{
    [self.debugView setNeedsDisplay];
}



@end
