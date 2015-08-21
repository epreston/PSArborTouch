//
//  ATSystemDebugView.h
//  SystemRig - System Test / Debug Rig
//
//  Created by Ed Preston on 1/10/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATSystem;

@interface ATSystemDebugView : UIView

@property (nonatomic, strong) ATSystem *system;
@property (nonatomic, assign, getter=isDebugDrawing) BOOL debugDrawing;

@end
