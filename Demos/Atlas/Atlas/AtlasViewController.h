//
//  AtlasViewController.h
//  Atlas - PSArborTouch Example
//
//  Created by Ed Preston on 3/10/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATSystemRenderer.h"

@class ATSystem;
@class AtlasCanvasView;

@interface AtlasViewController : UIViewController <ATDebugRendering, UIGestureRecognizerDelegate>
{

@private
    ATSystem    *system_;
    AtlasCanvasView *canvas_;
}

@property (nonatomic, strong) IBOutlet AtlasCanvasView *canvas;

@end
