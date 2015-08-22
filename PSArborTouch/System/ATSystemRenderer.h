//
//  ATSystemRenderer.h
//  PSArborTouch
//
//  Created by Ed Preston on 27/09/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

// Rendering protocols here.  Called in this order.
//      - Debug Rendering
//      - Edge Rendering
//      - Node Rendering



// Edge Rendering
//      - Edge
//      - Translated source point
//      - Translated target point


// Node Rendering
//      - Node
//      - Translated point


// Debug Rendering
//      - Barnes-Hut trees
//      - Bounds (physics and viewport)

@protocol ATDebugRendering <NSObject>

@required
- (void) redraw;

@end