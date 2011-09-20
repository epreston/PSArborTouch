//
//  NSMutableArray+QueueAdditions.h
//  PSArborTouch
//
//  Created by Ed Preston on 23/08/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end
