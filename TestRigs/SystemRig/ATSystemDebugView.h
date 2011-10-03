//
//  ATSystemDebugView.h
//  SystemRig - System Test / Debug Rig
//
//  Created by Ed Preston on 1/10/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATSystem;

@interface ATSystemDebugView : UIView
{
    
@private
    ATSystem *system_;
    BOOL debugDrawing_;
}

@property (nonatomic, retain) ATSystem *system;
@property (nonatomic, assign, getter=isDebugDrawing) BOOL debugDrawing;

@end
