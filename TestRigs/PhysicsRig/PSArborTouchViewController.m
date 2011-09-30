//
//  PSArborTouchViewController.m
//  PSArborTouch - Physics Test / Debug Rig
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "PSArborTouchViewController.h"
#import "ATPhysicsDebugView.h"

#import "ATPhysics.h"
#import "ATSpring.h"
#import "ATParticle.h"
#import "ATEnergy.h"

#import <QuartzCore/QuartzCore.h>

// Interval in seconds: make sure this is more than 0
#define kTimerInterval 0.05


@interface PSArborTouchViewController ()

- (IBAction) start:(id)sender;
- (IBAction) stop:(id)sender;
- (IBAction) reset:(id)sender;
- (IBAction) changeIntegrationMode:(id)sender;

- (void) stepPhysics;
- (IBAction) doPhysicsUpdate:(id)sender;
- (CGPoint) fromScreen:(CGPoint)p;
- (CGPoint) toScreen:(CGPoint)p;

- (void)addGestureRecognizersToPiece:(UIView *)piece;

@end


@implementation PSArborTouchViewController

@synthesize maxLabel = _maxLabel;
@synthesize meanLabel = _meanLabel;
@synthesize countLabel = _countLabel;
@synthesize sumLabel = _sumLabel;
@synthesize p1Name = _p1Name;
@synthesize p1Mass = _p1Mass;
@synthesize p1Position = _p1Position;
@synthesize p1Fixed = _p1Fixed;
@synthesize p2Name = _p2Name;
@synthesize p2Mass = _p2Mass;
@synthesize p2Position = _p2Position;
@synthesize p2Fixed = _p2Fixed;
@synthesize viewPort = _viewPort;
@synthesize particleView1 = _particleView1;
@synthesize particleView2 = _particleView2;
@synthesize particleView3 = _particleView3;
@synthesize particleView4 = _particleView4;
@synthesize statusLabel = _statusLabel;
@synthesize counterLabel = _counterLabel;
@synthesize barnesHutSwitch = _barnesHutSwitch;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _integrator = [[[ATPhysics alloc] initWithDeltaTime:0.02 
                                              stiffness:1000.0 
                                              repulsion:600.0 
                                               friction:0.5] retain];
    
    _viewPort.physics = _integrator;
    _viewPort.debugDrawing = YES;
    
    _integrator.gravity = NO;
    
    CGPoint pos = CGPointMake(0.3, 0.3);
    _particle1 = [[[ATParticle alloc] initWithName:@"Node 1" mass:1.0 position:pos fixed:NO] retain];
    [_integrator addParticle:_particle1];
    
    pos = CGPointMake(-0.7, -0.5);
    _particle2 = [[[ATParticle alloc] initWithName:@"Node 2" mass:1.0 position:pos fixed:NO] retain];
    [_integrator addParticle:_particle2];
    
    pos = CGPointMake(0.4, -0.5);
    _particle3 = [[[ATParticle alloc] initWithName:@"Node 3" mass:1.0 position:pos fixed:NO] retain];
    [_integrator addParticle:_particle3];
    
    pos = CGPointMake(-1.0, -1.0);
    _particle4 = [[[ATParticle alloc] initWithName:@"Node 4" mass:1.0 position:pos fixed:YES] retain];
    [_integrator addParticle:_particle4];
    
    
    _spring1 = [[[ATSpring alloc] initWithSource:_particle1 target:_particle2 length:1.0] retain];
    [_integrator addSpring:_spring1];
    
    _spring2 = [[[ATSpring alloc] initWithSource:_particle2 target:_particle3 length:1.0] retain];
    [_integrator addSpring:_spring2];
    
    _spring3 = [[[ATSpring alloc] initWithSource:_particle3 target:_particle1 length:1.0] retain];
    [_integrator addSpring:_spring3];
    
    _spring4 = [[[ATSpring alloc] initWithSource:_particle4 target:_particle1 length:1.0] retain];
    [_integrator addSpring:_spring4];
    
    _spring5 = [[[ATSpring alloc] initWithSource:_particle2 target:_particle4 length:1.0] retain];
    [_integrator addSpring:_spring5];
    
    [self addGestureRecognizersToPiece:_particleView1];
    [self addGestureRecognizersToPiece:_particleView2];
    [self addGestureRecognizersToPiece:_particleView3];
    [self addGestureRecognizersToPiece:_particleView4];
    
    
    _particle1.position = [self fromScreen:self.particleView1.center];
    _particle2.position = [self fromScreen:self.particleView2.center];
    _particle3.position = [self fromScreen:self.particleView3.center];
    _particle4.position = [self fromScreen:self.particleView4.center];
    
    _running = NO;
}


- (void) viewDidUnload
{
    
    BOOL timerInitialized = (_timer != nil);
    if ( timerInitialized ) {
        dispatch_source_cancel(_timer);
        dispatch_resume(_timer);  
        dispatch_release(_timer);
    }
    
    [self setSumLabel:nil];
    [self setMaxLabel:nil];
    [self setMeanLabel:nil];
    [self setCountLabel:nil];
    [self setP1Name:nil];
    [self setP1Mass:nil];
    [self setP1Position:nil];
    [self setP1Fixed:nil];
    [self setP2Name:nil];
    [self setP2Mass:nil];
    [self setP2Position:nil];
    [self setP2Fixed:nil];
    [self setParticleView1:nil];
    [self setParticleView2:nil];
    [self setViewPort:nil];
    [self setParticleView3:nil];
    [self setStatusLabel:nil];
    [self setCounterLabel:nil];
    [self setParticleView4:nil];
    [self setBarnesHutSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [_spring1 release];
    [_spring2 release];
    [_spring3 release];
    [_spring4 release];
    [_spring5 release];
    [_particle1 release];
    [_particle2 release];
    [_particle3 release];
    [_particle4 release];
    [_integrator release];
}


- (void)dealloc {
    
    [_sumLabel release];
    [_maxLabel release];
    [_meanLabel release];
    [_countLabel release];
    [_p1Name release];
    [_p1Mass release];
    [_p1Position release];
    [_p1Fixed release];
    [_p2Name release];
    [_p2Mass release];
    [_p2Position release];
    [_p2Fixed release];
    [_viewPort release];
    [_particleView1 release];
    [_particleView2 release];
    [_particleView3 release];
    [_statusLabel release];
    [_counterLabel release];
    [_particleView4 release];
    [_barnesHutSwitch release];
    [super dealloc];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (IBAction) start:(id)sender 
{
//    NSLog(@"Start button pressed.");
    
    BOOL timerNotInitialized = !_timer;
    if ( timerNotInitialized ) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        // create our timer source
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        // set the time to fire
        dispatch_source_set_timer(_timer,
                                  dispatch_time(DISPATCH_TIME_NOW, kTimerInterval * NSEC_PER_SEC),
                                  kTimerInterval * NSEC_PER_SEC, (kTimerInterval * NSEC_PER_SEC) / 2.0);
        
        // Hey, let's actually do something when the timer fires!
        dispatch_source_set_event_handler(_timer, ^{
            //            NSLog(@"WATCHDOG: task took longer than %f seconds",
            //                  kTimerInterval);
            
            // Call back to main thread (UI Thread) to update the text
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stepPhysics];
            });
            
            // ensure we never fire again
            // dispatch_source_cancel(_timer);
            
            // pause the timer
            // dispatch_suspend(_timer);
        });
    }
    
    self.statusLabel.text = @"RUNNING";
    
    _particle1.position = [self fromScreen:self.particleView1.center];
    _particle2.position = [self fromScreen:self.particleView2.center];
    _particle3.position = [self fromScreen:self.particleView3.center];
    _particle4.position = [self fromScreen:self.particleView4.center];
    
    if (_running == NO) {
        _running = YES;
        
        // now that our timer is all set to go, start it
        dispatch_resume(_timer);  
    }
}


- (IBAction) stop:(id)sender 
{
//    NSLog(@"Stop button pressed.");
    
    self.statusLabel.text = @"STOPPED";
    
    BOOL timerInitialized = (_timer != nil);
    if ( timerInitialized && _running ) {
        _running = NO;
        dispatch_suspend(_timer);
    }
}


- (IBAction) reset:(id)sender
{
//    NSLog(@"Reset button pressed.");
    
    CGPoint pos = CGPointMake(0.3, 0.3);
    _particle1.position = pos;
    
    pos = CGPointMake(-0.7, -0.5);
    _particle2.position = pos;
    
    pos = CGPointMake(0.4, -0.5);
    _particle3.position = pos;
    
    pos = CGPointMake(-1.0, -1.0);
    _particle4.position = pos;
}


- (IBAction) changeIntegrationMode:(id)sender 
{
    if (self.barnesHutSwitch.isOn) {
        _integrator.theta = 0.4;
        _viewPort.debugDrawing = YES;
    } else {
        _integrator.theta = 0.0;
        _viewPort.debugDrawing = NO;
    }
    
    [self start:nil];
}


- (IBAction) doPhysicsUpdate:(id)sender 
{
    self.statusLabel.text = @"STEPPING";
    
    [self stepPhysics];
}


- (void) stepPhysics
{   
    
    // Run physics loop.  Stop timer if it returns NO on update.
    if ([_integrator update] == NO) {
        [self stop:nil];
    }
    
    self.sumLabel.text      = [NSString stringWithFormat:@"%f", _integrator.energy.sum];
    self.maxLabel.text      = [NSString stringWithFormat:@"%f", _integrator.energy.max];
    self.meanLabel.text     = [NSString stringWithFormat:@"%f", _integrator.energy.mean];
    self.countLabel.text    = [NSString stringWithFormat:@"%f", _integrator.energy.count];
    
    self.p1Name.text        = _particle1.name;
    self.p1Mass.text        = [NSString stringWithFormat:@"%f", _particle1.mass];
    self.p1Position.text    = [NSString stringWithFormat:@"x = %f, y = %f", _particle1.position.x, _particle1.position.y];
    self.p1Fixed.text       = (_particle1.fixed) ? @"YES" : @"NO";
    
    self.p2Name.text        = _particle2.name;
    self.p2Mass.text        = [NSString stringWithFormat:@"%f", _particle2.mass];
    self.p2Position.text    = [NSString stringWithFormat:@"x = %f, y = %f", _particle2.position.x, _particle2.position.y];
    self.p2Fixed.text       = (_particle2.fixed) ? @"YES" : @"NO";
    
    self.particleView1.center = [self toScreen:_particle1.position];
    self.particleView2.center = [self toScreen:_particle2.position];
    self.particleView3.center = [self toScreen:_particle3.position];
    self.particleView4.center = [self toScreen:_particle4.position];
    
    _counter++;
    self.counterLabel.text = [NSString stringWithFormat:@"%d", _counter];
    
    [_viewPort setNeedsDisplay];
}


- (CGPoint) fromScreen:(CGPoint)p 
{
    CGSize size = self.viewPort.bounds.size;
    CGFloat midX = size.width / 2;
    CGFloat midY = size.height / 2;
    
    CGFloat scaleX = size.width / 10;
    CGFloat scaleY = size.height / 10;
    
    CGFloat sx  = (p.x - midX) / scaleX;
    CGFloat sy  = (p.y - midY) / scaleY ;
    
    return CGPointMake(sx, sy);
}


- (CGPoint) toScreen:(CGPoint)p 
{
    CGSize size = self.viewPort.bounds.size;
    CGFloat midX = size.width / 2;
    CGFloat midY = size.height / 2;
    
    CGFloat scaleX = size.width / 10;
    CGFloat scaleY = size.height / 10;
    
    CGFloat sx  = (p.x * scaleX) + midX;
    CGFloat sy  = (p.y * scaleY) + midY;
    
    return CGPointMake(sx, sy);
}





#pragma mark -         ZOMG SAMPLE CODE        -
#pragma mark === Setting up and tearing down ===
#pragma mark

// adds a set of gesture recognizers to one of our piece subviews
- (void) addGestureRecognizersToPiece:(UIView *)piece
{
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    [piece addGestureRecognizer:rotationGesture];
    [rotationGesture release];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [piece addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
    [panGesture release];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showResetMenu:)];
    [piece addGestureRecognizer:longPressGesture];
    [longPressGesture release];
}


#pragma mark -
#pragma mark === Utility methods  ===
#pragma mark

// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void) adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

// display a menu with a single item to allow the piece's transform to be reset
- (void) showResetMenu:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"Reset" action:@selector(resetPiece:)];
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        
        [self becomeFirstResponder];
        [menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
        
        pieceForReset = [gestureRecognizer view];
        
        [resetMenuItem release];
    }
}

// animate back to the default anchor point and transform
- (void) resetPiece:(UIMenuController *)controller
{
    CGPoint locationInSuperview = [pieceForReset convertPoint:CGPointMake(CGRectGetMidX(pieceForReset.bounds), CGRectGetMidY(pieceForReset.bounds)) toView:[pieceForReset superview]];
    
    [[pieceForReset layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    [pieceForReset setCenter:locationInSuperview];
    
    [UIView beginAnimations:nil context:nil];
    [pieceForReset setTransform:CGAffineTransformIdentity];
    [UIView commitAnimations];
}

// UIMenuController requires that we can become first responder or it won't display
- (BOOL) canBecomeFirstResponder
{
    return YES;
}


#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
- (void) panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    
    //[self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]]; 
    }
    
    [self start:nil];
}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void) rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void) scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
}

// ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously
// prevent other gesture recognizers from recognizing simultaneously
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // if the gesture recognizers's view isn't one of our pieces, don't allow simultaneous recognition
    if (gestureRecognizer.view != _particleView1 && 
        gestureRecognizer.view != _particleView2 && 
        gestureRecognizer.view != _particleView3 && 
        gestureRecognizer.view != _particleView4)
        return NO;
    
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}

@end
