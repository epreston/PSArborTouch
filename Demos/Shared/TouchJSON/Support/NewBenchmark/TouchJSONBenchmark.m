//
//  TouchJSONBenchmark.m
//  TouchJSON
//
//  Created by Jonathan Wight on 1/1/2000.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"

int main (int argc, const char * argv[])
    {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];


    NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        @"Hello", @"World",
        [NSNumber numberWithInt:42], @"Number",
        [NSNull null], @"Null",
        [NSNumber numberWithBool:YES], @"YES",
        [NSNumber numberWithBool:NO], @"NO",
        NULL];
        
    CJSONSerializer *theSerializer = [CJSONSerializer serializer];
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];

    NSData *theData = [theSerializer serializeObject:theDictionary error:NULL];
    NSLog(@"%@", [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease]);

    CFAbsoluteTime theStart = CFAbsoluteTimeGetCurrent();
    for (int N = 0; N != 400000; ++N)
        {
    ////    [theDeserizl serializeObject:theDictionary error:NULL];
        NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
        [theDeserializer deserialize:theData error:NULL];
        [thePool release];
        }



    CFAbsoluteTime theEnd = CFAbsoluteTimeGetCurrent();

    NSLog(@"%g", theEnd - theStart);


    [pool drain];
    return 0;
    }
