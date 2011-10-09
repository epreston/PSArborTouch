//
//  CJSONSerializer_UnitTests.m
//  TouchCode
//
//  Created by Jonathan Wight on 12/12/2005.
//  Copyright 2005 toxicsoftware.com. All rights reserved.
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

#import "CJSONSerializer_UnitTests.h"

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"

@implementation CJSONSerializer_UnitTests

- (void)testEmptyDictionary
    {
    NSString *jsonEquivalent = @"{}";
    NSDictionary *emptyDictionary = [NSDictionary dictionary];
    id theObject = [[CJSONSerializer serializer] serializeObject:emptyDictionary error:nil];
    STAssertEqualObjects([jsonEquivalent dataUsingEncoding:NSUTF8StringEncoding], theObject, nil);
    }

-(void)testSingleKeyValuePair
    {
    NSString *jsonEquivalent = @"{\"a\":\"b\"}";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"b" forKey:@"a"];
    id theObject = [[CJSONSerializer serializer] serializeObject:dictionary error:nil];
    STAssertEqualObjects([jsonEquivalent dataUsingEncoding:NSUTF8StringEncoding], theObject, nil);
    }

/* http://code.google.com/p/touchcode/issues/detail?id=52 */
-(void)test_SerializeArrayWithDuplicatedInstances
    {
    NSString *a = @"a";
    NSArray  *input = [NSArray arrayWithObjects:a, @"b", a, nil];
    NSData *expected = [@"[\"a\",\"b\",\"a\"]" dataUsingEncoding:NSUTF8StringEncoding];
    id output = [[CJSONSerializer serializer] serializeObject:input error:nil];
    STAssertEqualObjects(expected, output, nil);
    }

- (void)testFalse
    {
    NSString *jsonEquivalent = @"{\"a\":false}";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"a"];
    id theObject = [[CJSONSerializer serializer] serializeObject:dictionary error:nil];
    STAssertEqualObjects([jsonEquivalent dataUsingEncoding:NSUTF8StringEncoding], theObject, nil);
    }

- (void)testDoubleAccuracy
    {
    NSString *jsonEquivalent = @"{\"a\":1.23456789}";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:1.23456789] forKey:@"a"];
    id theObject = [[CJSONSerializer serializer] serializeObject:dictionary error:nil];
    STAssertEqualObjects([jsonEquivalent dataUsingEncoding:NSUTF8StringEncoding], theObject, nil);
    }

- (void)testLineBreaksInStrings
    {
    NSString *jsonEquivalent = @"{\"a\":\"line\\nbreak\"}";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"line\nbreak" forKey:@"a"];
    id theObject = [[CJSONSerializer serializer] serializeObject:dictionary error:nil];
    NSString *resultString = [[[NSString alloc] initWithData:theObject encoding:NSUTF8StringEncoding] autorelease];
    STAssertEqualObjects(resultString, jsonEquivalent, nil);
    }

- (void)testCarriageReturnsInStrings
    {
    NSString *jsonEquivalent = @"{\"a\":\"carriage\\rreturn\"}";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"carriage\rreturn" forKey:@"a"];
    id theObject = [[CJSONSerializer serializer] serializeObject:dictionary error:nil];
    NSString *resultString = [[[NSString alloc] initWithData:theObject encoding:NSUTF8StringEncoding] autorelease];
    STAssertEqualObjects(resultString, jsonEquivalent, nil);
    }

- (void)testTabsInStrings
    {
    NSString *jsonEquivalent = @"{\"a\":\"tab\\there\"}";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"tab\there" forKey:@"a"];
    id theObject = [[CJSONSerializer serializer] serializeObject:dictionary error:nil];
    NSString *resultString = [[[NSString alloc] initWithData:theObject encoding:NSUTF8StringEncoding] autorelease];
    STAssertEqualObjects(resultString, jsonEquivalent, nil);
    }

- (void)testFormfeedsInStrings
    {
    NSString *jsonEquivalent = @"{\"a\":\"formfeed\\fhere\"}";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"formfeed\fhere" forKey:@"a"];
    id theObject = [[CJSONSerializer serializer] serializeObject:dictionary error:nil];
    NSString *resultString = [[[NSString alloc] initWithData:theObject encoding:NSUTF8StringEncoding] autorelease];
    STAssertEqualObjects(resultString, jsonEquivalent, nil);
    }

- (void)testBackspaceInStrings
    {
    NSString *jsonEquivalent = @"{\"a\":\"backspace\\bhere\"}";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"backspace\bhere" forKey:@"a"];
    id theObject = [[CJSONSerializer serializer] serializeObject:dictionary error:nil];
    NSString *resultString = [[[NSString alloc] initWithData:theObject encoding:NSUTF8StringEncoding] autorelease];
    STAssertEqualObjects(resultString, jsonEquivalent, nil);
    }

- (void)testDoubleQuotesInStrings
    {
    NSString *jsonEquivalent = @"{\"a\":\"double\\\"quote\"}";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"double\"quote" forKey:@"a"];
    id theObject = [[CJSONSerializer serializer] serializeObject:dictionary error:nil];
    NSString *resultString = [[[NSString alloc] initWithData:theObject encoding:NSUTF8StringEncoding] autorelease];
    STAssertEqualObjects(resultString, jsonEquivalent, nil);
    }

- (void)testBackslashInStrings
    {
    NSString *jsonEquivalent = @"{\"a\":\"back\\\\slash\"}";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"back\\slash" forKey:@"a"];
    id theObject = [[CJSONSerializer serializer] serializeObject:dictionary error:nil];
    NSString *resultString = [[[NSString alloc] initWithData:theObject encoding:NSUTF8StringEncoding] autorelease];
    STAssertEqualObjects(resultString, jsonEquivalent, nil);
    }

- (void)testMultibytesStrings_1
    {
    NSError *theError = NULL;
    NSData *theData = [@"\"80\u540e\uff0c\u5904\u5973\u5ea7\uff0c\u65e0\u4e3b\u7684\u808b\u9aa8\uff0c\u5b85+\u5fae\u8150\u3002\u5b8c\u7f8e\u63a7\uff0c\u7ea0\u7ed3\u63a7\u3002\u5728\u76f8\u4eb2\u7684\u6253\u51fb\u4e0e\u88ab\u6253\u51fb\u4e2d\u4e0d\u65ad\u6210\u957fing\"" dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *theData = [@"\"\u062a\u062d\u064a\u0627 \u0645\u0635\u0631!\"" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *theString = [[CJSONDeserializer deserializer] deserialize:theData error:&theError];
    theData = [[CJSONSerializer serializer] serializeObject:theString error:&theError];
    theString = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
    STAssertNotNil(theString, @"fail");
    }

- (void)testMultibytesStrings_2
    {
    NSError *theError = NULL;
    NSData *theData = [@"\"\u062a\u062d\u064a\u0627 \u0645\u0635\u0631!\"" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *theString = [[CJSONDeserializer deserializer] deserialize:theData error:&theError];
    theData = [[CJSONSerializer serializer] serializeObject:theString error:&theError];
    theString = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
    STAssertNotNil(theString, @"fail");
    }

- (void)testMultibytesStrings_3
    {
    NSError *theError = NULL;
    NSData *theData = [@"\"@janl \u24b6\u24c1\u24cc\u24b6\u24ce\u24c8 \u24cc\u24b6\u24ce\u24c8 \u24c9\u24c4 \u24be\u24c2\u24c5\u24c7\u24c4\u24cb\u24ba, \u24c9\u24bd\u24c4\u24ca\u24bc\u24bd\"" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *theString = [[CJSONDeserializer deserializer] deserialize:theData error:&theError];
    theData = [[CJSONSerializer serializer] serializeObject:theString error:&theError];
    theString = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
    STAssertNotNil(theString, @"fail");
    }




@end
