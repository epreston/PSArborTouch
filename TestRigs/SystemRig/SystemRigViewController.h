//
//  SystemRigViewController.h
//  SystemRig - System Test / Debug Rig
//
//  Created by Ed Preston on 26/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATSystemRenderer.h"

@class ATSystem;
@class ATSystemDebugView;

@interface SystemRigViewController : UIViewController <UIGestureRecognizerDelegate, ATDebugRendering>
{
    
@private
    ATSystem *system_;
    ATSystemDebugView *debugView_;
}

@property (nonatomic, strong) IBOutlet ATSystemDebugView *debugView;

@end
