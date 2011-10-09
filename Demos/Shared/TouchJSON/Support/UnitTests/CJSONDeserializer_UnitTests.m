//
//  CJSONDeserializer_UnitTests.m
//  TouchCode
//
//  Created by Luis de la Rosa on 8/6/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

#import "CJSONDeserializer_UnitTests.h"
#import "CJSONDeserializer.h"
#import "CJSONScanner.h"


@implementation CJSONDeserializer_UnitTests

-(void)testEmptyDictionary
    {
	NSString *theSource = @"{}";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *theObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:theData error:nil];
	NSDictionary *dictionary = [NSDictionary dictionary];
	STAssertEqualObjects(dictionary, theObject, nil);
    }

-(void)testSingleKeyValuePair
    {
	NSString *theSource = @"{\"a\":\"b\"}";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *theObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:theData error:nil];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"b" forKey:@"a"];
	STAssertEqualObjects(dictionary, theObject, nil);
    }

-(void)testRootArray
    {
	NSString *theSource = @"[\"a\",\"b\",\"c\"]";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSArray *theObject = [[CJSONDeserializer deserializer] deserializeAsArray:theData error:nil];
	NSArray *theArray = [NSArray arrayWithObjects:@"a", @"b", @"c", NULL];
	STAssertEqualObjects(theArray, theObject, nil);
    }

-(void)testDeserializeDictionaryWithNonDictionary
    {
	NSString *emptyArrayInJSON = @"[]";
	NSData *emptyArrayInJSONAsData = [emptyArrayInJSON dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *deserializedDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:emptyArrayInJSONAsData error:nil];
	STAssertNil(deserializedDictionary, nil);
    }

-(void)testDeserializeDictionaryWithAnEmbeddedArray
    {
	NSString *theSource = @"{\"version\":\"1.0\", \"method\":\"a_method\", \"params\":[ \"a_param\" ]}";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *theObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:theData error:nil];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								@"1.0", @"version",
								@"a_method", @"method",
								[NSArray arrayWithObject:@"a_param"], @"params",
								nil];
	STAssertEqualObjects(dictionary, theObject, nil);	
    }

-(void)testDeserializeDictionaryWithAnEmbeddedArrayWithWhitespace
    {
	NSString *theSource = @"{\"version\":\"1.0\", \"method\":\"a_method\", \"params\":    [ \"a_param\" ]}";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *theObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:theData error:nil];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								@"1.0", @"version",
								@"a_method", @"method",
								[NSArray arrayWithObject:@"a_param"], @"params",
								nil];
	STAssertEqualObjects(dictionary, theObject, nil);	
    }


-(void)testCheckForError
    {
	NSString *jsonString = @"!";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithEmptyJSON
    {
	NSString *jsonString = @"";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithEmptyJSONAndIgnoringError
    {
	NSString *jsonString = @"";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithNilJSON
    {
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:nil error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithNilJSONAndIgnoringError
    {
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:nil error:nil];
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testNoError
    {
	NSString *jsonString = @"{}";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	STAssertNil(error, @"No error should be reported when deserializing an empty dictionary", nil);
	STAssertNotNil(dictionary, @"Dictionary will be nil when there is not an error deserializing", nil);
    }

#pragma mark DeprecatedTests
-(void)testCheckForError_Deprecated
    {
	NSString *jsonString = @"{!";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithEmptyJSON_Deprecated
    {
	NSString *jsonString = @"";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithEmptyJSONAndIgnoringError_Deprecated
    {
	NSString *jsonString = @"";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:jsonData error:nil];
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithNilJSON_Deprecated
    {
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:nil error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithNilJSONAndIgnoringError_Deprecated
    {
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:nil error:nil];
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testSkipNullValueInArray
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.nullObject = NULL;
    NSData *theData = [@"[null]" dataUsingEncoding:NSUTF8StringEncoding];
	NSArray *theArray = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theArray, [NSArray array], @"Skipping null did not produce empty array");
    }

-(void)testAlternativeNullValueInArray
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.nullObject = @"foo";
    NSData *theData = [@"[null]" dataUsingEncoding:NSUTF8StringEncoding];
	NSArray *theArray = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theArray, [NSArray arrayWithObject:@"foo"], @"Skipping null did not produce array with placeholder");
    }

-(void)testDontSkipNullValueInArray
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"[null]" dataUsingEncoding:NSUTF8StringEncoding];
	NSArray *theArray = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theArray, [NSArray arrayWithObject:[NSNull null]], @"Didnt get the array we were looking for");
    }

-(void)testSkipNullValueInDictionary
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.nullObject = NULL;
    NSData *theData = [@"{\"foo\":null}" dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, [NSDictionary dictionary], @"Skipping null did not produce empty dict");
    }

-(void)testMultipleRuns
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"{\"hello\":\"world\"}" dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, [NSDictionary dictionaryWithObject:@"world" forKey:@"hello"], @"Dictionary did not contain expected contents");
    theData = [@"{\"goodbye\":\"cruel world\"}" dataUsingEncoding:NSUTF8StringEncoding];
	theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, [NSDictionary dictionaryWithObject:@"cruel world" forKey:@"goodbye"], @"Dictionary did not contain expected contents");
    }

-(void)testWindowsCP1252StringEncoding
    {
	CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	NSString *jsonString = @"[\"Expos\u00E9\"]";
	NSData *jsonData = [jsonString dataUsingEncoding:NSWindowsCP1252StringEncoding];
	NSError *error = nil;
	NSArray *array = [theDeserializer deserialize:jsonData error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a non unicode JSON string", nil);
	STAssertEqualObjects([error domain], kJSONScannerErrorDomain, @"The error must be of the CJSONDeserializer error domain");
	STAssertEquals([error code], (NSInteger)kJSONScannerErrorCode_CouldNotDecodeData, @"The error must be 'Invalid encoding'");
	theDeserializer.allowedEncoding = NSWindowsCP1252StringEncoding;
	array = [theDeserializer deserialize:jsonData error:nil];
	STAssertEqualObjects(array, [NSArray arrayWithObject:@"Expos\u00E9"], nil);
    }


-(void)testLargeNumbers
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"14399073641566209" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEquals([theObject unsignedLongLongValue], 14399073641566209ULL, @"Numbers did not contain expected contents");
    }


@end

