//
//  main.m
//  TouchCode
//
//  Created by Jonathan Wight on 20090528.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "CJSONScanner.h"

static void test(void);
static void test_repeated_array(void);
static void test_twitter_public_timeline(void);


int main(int argc, char **argv)
	{
	#pragma unused(argc, argv)

	NSAutoreleasePool *theAutoreleasePool = [[NSAutoreleasePool alloc] init];

//  test();
//    test_twitter_public_timeline();
     test_repeated_array();

	[theAutoreleasePool release];
	//
	return(0);
	}


static void test(void)
    {
    NSError *theError = NULL;
    NSData *theData = [@"{(\n)}" dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *theData = [@"\"\u062a\u062d\u064a\u0627 \u0645\u0635\u0631!\"" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *theString = [[CJSONDeserializer deserializer] deserialize:theData error:&theError];
    theData = [[CJSONSerializer serializer] serializeObject:theString error:&theError];
    theString = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@", theString);
    }


static void test_repeated_array(void)
    {
    NSString* a = @"a";
    NSArray* array = [NSArray arrayWithObjects:a, @"b", a, nil];

    NSError *theError = NULL;
    NSData *theData = [[CJSONSerializer serializer] serializeObject:array error:&theError];
    NSString *theString = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@", theString);

    }

static void test_twitter_public_timeline(void)
	{
    NSError *theError = NULL;
    NSData *inputData = [NSData dataWithContentsOfFile:@"Test Data/atomicbird.json"];
    NSLog(@"Input data: %ld", inputData.length);
    id json = [[CJSONDeserializer deserializer] deserialize:inputData error:&theError];
    NSLog(@"JSON Object: %@ %p (Error: %@)", [json class], json, theError);
    NSData *jsonData = [[CJSONSerializer serializer] serializeObject:json error:&theError];
    NSLog(@"%@", jsonData);
    
    NSLog(@"JSON data: %ld  (Error: %@)", jsonData.length, theError);
    NSString *jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"JSON string: %ld", jsonString.length);
    NSLog(@"> %@", jsonString);
	}
