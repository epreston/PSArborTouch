//
//  AtlasViewController.m
//  Atlas - PSArborTouch Example
//
//  Created by Ed Preston on 3/10/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "AtlasViewController.h"

#import "PSArborTouch.h"

@implementation AtlasViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create our particle system
    system_ = [[[ATSystem alloc] init] retain];
    
    // Configure simulation parameters, (take a copy, modify it, update the system when done.)
    ATSystemParams *params = system_.parameters;
    
    params.repulsion = 4000.0;
    params.stiffness = 500.0;
    params.friction  = 0.5;
    
    system_.parameters = params;
    
    // Setup the view bounds
    system_.viewBounds = self.view.bounds;
    
    // leave some space at the bottom and top for text
    system_.viewPadding = UIEdgeInsetsMake(100.0, 60.0, 60.0, 60.0);
    
    // have the ‘camera’ zoom somewhat slowly as the graph unfolds 
    system_.viewTweenStep = 0.02;
    
    // set this controller as the system's delegate
    system_.delegate = self;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [system_ release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ( UIInterfaceOrientationIsLandscape(interfaceOrientation) ) {
        return YES;
    }
    
    return NO;
}


#pragma mark - Rendering

- (void) redraw
{
    [self.view setNeedsDisplay];
}


#pragma mark - Interface Actions

- (IBAction)launchSourceURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL 
    URLWithString:@"http://www.statemaster.com/graph/geo_lan_bou_bor_cou-geography-land-borders"]];
}

@end
