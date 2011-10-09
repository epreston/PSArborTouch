//
//  EcholaliaCanvasView.h
//  Echolalia - PSArborTouch Example
//
//  Created by Ed Preston on 4/10/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATSystem;

@interface EcholaliaCanvasView : UIView
{
@private
    ATSystem *system_;
    BOOL debugDrawing_;
    UIFont *font_;
}

@property (nonatomic, retain) ATSystem *system;
@property (nonatomic, assign, getter=isDebugDrawing) BOOL debugDrawing;

@end
