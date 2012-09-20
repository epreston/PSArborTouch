//
//  KernelRigViewController.m
//  KernelRig - Kernel Test / Debug Rig
//
//  Created by Ed Preston on 22/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "KernelRigViewController.h"
#import "ATKernelDebugView.h"
#import "ATKernel.h"
#import "ATSpring.h"
#import "ATParticle.h"


@implementation KernelRigViewController

@synthesize debugView = _debugView;

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _kernel = [[[ATKernel alloc] init] retain];
    
    _kernel.delegate = self;
    
    self.debugView.physics = _kernel.physics;
    self.debugView.debugDrawing = YES;
    
    
    ATParticle  *_particle1;
    ATParticle  *_particle2;
    ATParticle  *_particle3;
    ATParticle  *_particle4;
    ATSpring    *_spring1;
    ATSpring    *_spring2;
    ATSpring    *_spring3;
    ATSpring    *_spring4;
    ATSpring    *_spring5;
    
    CGPoint pos = CGPointMake(0.3, 0.3);
    _particle1 = [[[ATParticle alloc] initWithName:@"Node 1" mass:1.0 position:pos fixed:NO] autorelease];
    [_kernel addParticle:_particle1];
    
    pos = CGPointMake(-0.7, -0.5);
    _particle2 = [[[ATParticle alloc] initWithName:@"Node 2" mass:1.0 position:pos fixed:NO] autorelease];
    [_kernel addParticle:_particle2];
    
    pos = CGPointMake(0.4, -0.5);
    _particle3 = [[[ATParticle alloc] initWithName:@"Node 3" mass:1.0 position:pos fixed:NO] autorelease];
    [_kernel addParticle:_particle3];
    
    pos = CGPointMake(-1.0, -1.0);
    _particle4 = [[[ATParticle alloc] initWithName:@"Node 4" mass:1.0 position:pos fixed:YES] autorelease];
    [_kernel addParticle:_particle4];
    
    
    _spring1 = [[[ATSpring alloc] initWithSource:_particle1 target:_particle2 length:1.0] autorelease];
    [_kernel addSpring:_spring1];
    
    _spring2 = [[[ATSpring alloc] initWithSource:_particle2 target:_particle3 length:1.0] autorelease];
    [_kernel addSpring:_spring2];
    
    _spring3 = [[[ATSpring alloc] initWithSource:_particle3 target:_particle1 length:1.0] autorelease];
    [_kernel addSpring:_spring3];
    
    _spring4 = [[[ATSpring alloc] initWithSource:_particle4 target:_particle1 length:1.0] autorelease];
    [_kernel addSpring:_spring4];
    
    _spring5 = [[[ATSpring alloc] initWithSource:_particle2 target:_particle4 length:1.0] autorelease];
    [_kernel addSpring:_spring5];
}


- (void) viewDidUnload
{
    [self setDebugView:nil];
    [super viewDidUnload];

    
    
    [_kernel release];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for landscape orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void) dealloc {
    [_debugView release];
    [super dealloc];
}


#pragma mark - Interface Actions

- (IBAction) go:(id)sender
{
    [_kernel start:YES];
}



#pragma mark - ATDebugRendering Protocol

- (void) redraw
{
    [self.debugView setNeedsDisplay];
}


@end
