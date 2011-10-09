//
//  CJSONScanner_UnitTests.m
//  TouchCode
//
//  Created by Jonathan Wight on 12/07/2005.
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

#import "CJSONScanner_UnitTests.h"

#import "CJSONScanner.h"

static id TXPropertyList(NSString *inString)
    {
    NSData *theData = [inString dataUsingEncoding:NSUTF8StringEncoding];

    NSPropertyListFormat theFormat;
    NSString *theError = NULL;

    id thePropertyList = [NSPropertyListSerialization propertyListFromData:theData mutabilityOption:NSPropertyListImmutable format:&theFormat errorDescription:&theError];
    return(thePropertyList);
    }

static BOOL Scan(NSString *inString, id *outResult, NSDictionary *inOptions)
    {
    CJSONScanner *theScanner = [[[CJSONScanner alloc] initWithData:[inString dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    for (NSString *theKey in inOptions)
        {
        id theValue = [inOptions objectForKey:theKey];
        [theScanner setValue:theValue forKey:theKey];	
        }
    BOOL theResult = [theScanner scanJSONObject:outResult error:NULL];
    return(theResult);
    }

@implementation CJSONScanner_UnitTests

- (void)testTrue
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"true", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject boolValue] == YES, @"Result of scan didn't match expectations.");
    }

- (void)testFalse
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"false", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject boolValue] == NO, @"Result of scan didn't match expectations.");
    }

- (void)testNull
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"null", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:[NSNull null]], @"Result of scan didn't match expectations.");
    }

- (void)testNumber
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"3.14", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertEqualsWithAccuracy([theObject doubleValue], 3.14, 0.001, @"Result of scan didn't match expectations.");
    }

- (void)testEngineeringNumber
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"3.14e4", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject doubleValue] == 3.14e4, @"Result of scan didn't match expectations.");
    }

- (void)testEngineeringNumber2
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"-3.433021e+07", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject doubleValue] == -3.433021e+07, @"Result of scan didn't match expectations.");
    }

- (void)testNegativeNumber
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"-1", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject doubleValue] == -1, @"Result of scan didn't match expectations.");
    }

- (void)testLargeNumber
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"14399073641566209", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject unsignedLongLongValue] == 14399073641566209, @"Result of scan didn't match expectations.");
    }

- (void)testLargeNegativeNumber
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"-14399073641566209", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject longLongValue] == -14399073641566209, @"Result of scan didn't match expectations.");
    }

#pragma mark -

- (void)testString
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"\"Hello world.\"", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:@"Hello world."], @"Result of scan didn't match expectations.");

    theResult = Scan(@"    \"Hello world.\"      ", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:@"Hello world."], @"Result of scan didn't match expectations.");
    }

- (void)testUnicode
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"\"••••Über©©©©\"", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:@"••••Über©©©©"], @"Result of scan didn't match expectations.");
    }

- (void)testStringEscaping
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"\"\\r\\n\\f\\b\\\\\"", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:@"\r\n\f\b\\"], @"Result of scan didn't match expectations.");
    }

- (void)testStringEscaping2
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"\"Hello\r\rworld.\"", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:@"Hello\r\rworld."], @"Result of scan didn't match expectations.");
    }

- (void)testStringUnicodeEscaping
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"\"x\\u0078xx\"", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:@"xxxx"], @"Result of scan didn't match expectations.");
    }

- (void)testStringLooseEscaping
    {
    id theObject = NULL;

    NSDictionary *theOptions = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithBool:NO], @"strictEscapeCodes",
        NULL];

    BOOL theResult = Scan(@"\"Hello\\ World.\"", &theObject, theOptions);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:@"Hello World."], @"Result of scan didn't match expectations.");
    }

- (void)testStringStrictEscaping
    {
    id theObject = NULL;

    NSDictionary *theOptions = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithBool:YES], @"strictEscapeCodes",
        NULL];

    BOOL theResult = Scan(@"\"Hello\\ World.\"", &theObject, theOptions);
    STAssertFalse(theResult, @"Scan return failure.");
    }


#pragma mark -

- (void)testSimpleDictionary
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"{\"bar\":\"foo\"}", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:TXPropertyList(@"{bar = foo; }")], @"Result of scan didn't match expectations.");
    }

- (void)testNestedDictionary
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"{\"bar\":{\"bar\":\"foo\"}}", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:TXPropertyList(@"{bar = {bar = foo; }; }")], @"Result of scan didn't match expectations.");
    }

#pragma mark -

- (void)testSimpleArray
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"[\"bar\",\"foo\"]", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:TXPropertyList(@"(bar, foo)")], @"Result of scan didn't match expectations.");
    }

- (void)testNestedArray
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"[\"bar\",[\"bar\",\"foo\"]]", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:TXPropertyList(@"(bar, (bar, foo))")], @"Result of scan didn't match expectations.");
    }

#pragma mark -

- (void)testWhitespace1
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"    \"Hello world.\"      ", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:@"Hello world."], @"Result of scan didn't match expectations.");
    }

- (void)testWhitespace2
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"[ true, false ]", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    //STAssertTrue([theObject isEqual:TXPropertyList(@"(1, 0)")], @"Result of scan didn't match expectations.");
    }

- (void)testWhitespace3
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"{ \"x\" : [ 1 , 2 ] }", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    //STAssertTrue([theObject isEqual:TXPropertyList(@"{x, (1, 2)}")], @"Result of scan didn't match expectations.");
    }

#pragma mark -

- (void)testComments1
    {
    //id theObject = NULL;
    //BOOL theResult = Scan(@"/* cmt */ [ 1, /* cmt */ 2 ] /* cmt */", &theObject, NULL);
    //STAssertTrue(theResult, @"Scan return failure.");
    //STAssertTrue([theObject isEqual:TXPropertyList(@"(1, 2)")], @"Result of scan didn't match expectations.");
    }


/*
- (void)testComments2
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"[ 1, // cmt \r 2 ]", &theObjec, NULLt);
    STAssertTrue(theResult, @"Scan return failure.");
    //STAssertTrue([theObject isEqual:TXPropertyList(@"(1, 2)")], @"Result of scan didn't match expectations.");
    }
    */

#pragma mark -

- (void)testNegative
    {
    //id theObject = NULL;
    //STAssertThrows(Scan(@"[", &theObject), @"Incomplete array.", NULL);
    }

#pragma mark -

- (void)testBlakesCode
    {
    id theObject = NULL;
    BOOL theResult = Scan([NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"Blake" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil], &theObject, NULL);
    STAssertTrue(theResult, @"Scan returned failure");
    }

- (void)testExtraCommasInDictionary
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"{\r\"title\": \"space - Everyone's Tagged Photos\",\r}", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:TXPropertyList(@"{title = \"space - Everyone's Tagged Photos\"; }")], @"Result of scan didn't match expectations.");
    }

- (void)testEmptyArray1
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"[]", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:TXPropertyList(@"()")], @"Result of scan didn't match expectations.");
    }

- (void)testEmptyArray2
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"[ ]", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:TXPropertyList(@"()")], @"Result of scan didn't match expectations.");
    }

- (void)testEmptyDictionary1
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"{}", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    //STAssertTrue([theObject isEqual:TXPropertyList(@"{}")], @"Result of scan didn't match expectations.");
    }

- (void)testEmptyDictionary2
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"{\"Foo\":{}}", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:TXPropertyList(@"{Foo = { }; }")], @"Result of scan didn't match expectations.");
    }

- (void)testEmptyDictionary3
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"{ }", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    STAssertTrue([theObject isEqual:TXPropertyList(@"{}")], @"Result of scan didn't match expectations.");
    }

- (void)testDanielPascoCode1
    {
    id theObject = NULL;
    NSString *theSource = @"{\"status\": \"ok\", \"operation\": \"new_task\", \"task\": {\"status\": 0, \"updated_at\": {}, \"project_id\": 7179, \"dueDate\": null, \"creator_id\": 1, \"type_id\": 0, \"priority\": 1, \"id\": 37087, \"summary\": \"iPhone test\", \"description\": null, \"creationDate\": {}, \"owner_id\": 1, \"noteCount\": 0, \"commentCount\": 0}}";
    BOOL theResult = Scan(theSource, &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    }

- (void)testDanielPascoCode2
    {
    id theObject = NULL;
    NSString *theSource = @"{\"status\": \"ok\", \"operation\": \"new_task\", \"task\": {\"status\": 0, \"project_id\": 7179, \"dueDate\": null, \"creator_id\": 1, \"type_id\": 0, \"priority\": 1, \"id\": 37087, \"summary\": \"iPhone test\", \"description\": null, \"owner_id\": 1, \"noteCount\": 0, \"commentCount\": 0}}";
    BOOL theResult = Scan(theSource, &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    }

- (void)testTomHaringtonCode1
    {
    id theObject = NULL;
    NSString *theSource = @"{\"r\":[{\"name\":\"KEXP\",\"desc\":\"90.3 - Where The Music Matters\",\"icon\":\"\\/img\\/channels\\/radio_stream.png\",\"audiostream\":\"http:\\/\\/kexp-mp3-1.cac.washington.edu:8000\\/\",\"type\":\"radio\",\"stream\":\"fb8155000526e0abb5f8d1e02c54cb83094cffae\",\"relay\":\"r2b\"}]}";
    BOOL theResult = Scan(theSource, &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    }

#pragma mark -

- (void)testScottyCode1
    {
    // This should fail.
    id theObject = NULL;
    NSString *theSource = @"{\"a\": [ { ] }";
    BOOL theResult = Scan(theSource, &theObject, NULL);
    STAssertFalse(theResult, @"Scan return failure.");
    STAssertTrue(theObject == NULL, @"Scan return failure.");
    }

- (void)testUnterminatedString
    {
    // This should fail.
    id theObject = NULL;
    NSString *theSource = @"\"";
    BOOL theResult = Scan(theSource, &theObject, NULL);
    STAssertFalse(theResult, @"Scan return failure.");
    STAssertTrue(theObject == NULL, @"Scan return failure.");
    }

- (void)testGarbageCharacter
    {
    // This should fail.
    id theObject = NULL;
    NSString *theSource = @">";
    BOOL theResult = Scan(theSource, &theObject, NULL);
    STAssertFalse(theResult, @"Scan return failure.");
    STAssertTrue(theObject == NULL, @"Scan return failure.");
    }

@end
