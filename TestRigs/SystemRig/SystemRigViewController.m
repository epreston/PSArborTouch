//
//  SystemRigViewController.m
//  SystemRig - System Test / Debug Rig
//
//  Created by Ed Preston on 26/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "SystemRigViewController.h"
#import "ATSystemDebugView.h"
#import "ATSystem.h"
#import "ATPhysics.h"
#import "ATNode.h"

@implementation SystemRigViewController
@synthesize debugView = debugView_;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    system_ = [[[ATSystem alloc] init] retain];
    
    system_.viewBounds = self.view.bounds;
    system_.viewPadding = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
    system_.delegate = self;
//    system.physics.theta = 0.0;
    
    self.debugView.system = system_;
    self.debugView.debugDrawing = YES;
    
    // add some nodes to the graph and watch it go...
    [system_ addEdgeFromNode:@"a" toNode:@"b" withData:nil];
    [system_ addEdgeFromNode:@"a" toNode:@"c" withData:nil];
    [system_ addEdgeFromNode:@"a" toNode:@"d" withData:nil];
    [system_ addEdgeFromNode:@"a" toNode:@"e" withData:nil];
    
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
    [panGesture release];
}

- (void)viewDidUnload
{
    [self setDebugView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [system_ release];
}

- (void)dealloc {
    [debugView_ release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


#pragma mark - Interface Actions

- (IBAction)go:(id)sender
{
    [system_ start:YES];
}

- (IBAction)add:(id)sender
{
    [system_ addEdgeFromNode:@"a" toNode:@"e" withData:nil];
    
    [self go:nil];
}

- (IBAction)remove:(id)sender
{
    [system_ removeNode:@"e"];
    
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
        
        ATNode *node = [system_ nearestNodeToPoint:translation withinRadius:500.0];
        
//        translation = [self fromScreen:translation];
        
        if (node) {
            node.position = CGPointMake(node.position.x + translation.x, node.position.y + translation.y);
            
            [system_ start:YES];
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
