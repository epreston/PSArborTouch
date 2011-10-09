//
//  EcholaliaViewController.h
//  Echolalia - PSArborTouch Example
//
//  Created by Ed Preston on 3/10/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATSystemRenderer.h"

@class ATSystem;
@class EcholaliaCanvasView;

@interface EcholaliaViewController : UIViewController <ATDebugRendering, UIGestureRecognizerDelegate>
{
    
@private
    ATSystem    *system_;
    EcholaliaCanvasView *canvas_;
}

@property (nonatomic, retain) IBOutlet EcholaliaCanvasView *canvas;

@end
