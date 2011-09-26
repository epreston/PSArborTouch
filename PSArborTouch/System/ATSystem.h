//
//  ATSystem.h
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ATKernel.h"

@interface ATSystem : ATKernel
{
    
@private
    
    
}


// Keep track of current fps, only work as hard as requested fps

@property (nonatomic, assign) CGFloat fps;


@end
