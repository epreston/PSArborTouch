//
//  NSMutableArray+QueueAdditions.m
//  PSArborTouch
//
//  Created by Ed Preston on 23/08/11.
//  Copyright 2011 Preston Software. All rights reserved.
//
//  http://stackoverflow.com/questions/817469/how-do-i-make-and-use-a-queue-in-objective-c
// 
//


#import "NSMutableArray+QueueAdditions.h"


@implementation NSMutableArray (QueueAdditions)
// Queues are first-in-first-out, so we remove objects from the head
- (id) dequeue 
{
    if ([self count] == 0) return nil; // to avoid raising exception (Quinn)
    id headObject = [self objectAtIndex:0];
    if (headObject != nil) {
        [[headObject retain] autorelease]; // so it isn't dealloc'ed on remove
        [self removeObjectAtIndex:0];
    }
    return headObject;
}

// Add to the tail of the queue (no one likes it when people cut in line!)
- (void) enqueue:(id)anObject 
{
    if (anObject == nil) return;
    [self addObject:anObject];
    //this method automatically adds to the end of the array
}
@end