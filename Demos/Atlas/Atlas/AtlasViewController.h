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

@interface AtlasViewController : UIViewController <ATDebugRendering>
{

@private
    ATSystem    *system_;
}
@end
