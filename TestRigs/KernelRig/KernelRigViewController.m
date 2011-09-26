//
//  KernelRigViewController.m
//  KernelRig - Kernel Test / Debug Rig
//
//  Created by Ed Preston on 22/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "KernelRigViewController.h"
#import "ATPhysicsDebugView.h"
#import "ATKernel.h"


@implementation KernelRigViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _kernel = [[[ATKernel alloc] init] retain];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    
    
    [_kernel release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
