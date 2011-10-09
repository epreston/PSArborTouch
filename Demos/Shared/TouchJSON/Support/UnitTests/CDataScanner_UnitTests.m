//
//  CDataScanner_UnitTests.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/16/08.
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

#import "CDataScanner_UnitTests.h"

#import "CDataScanner.h"
#import "CDataScanner_Extensions.h"

@implementation CDataScanner_UnitTests

- (void)testSomething
    {
    CDataScanner *theScanner = [[[CDataScanner alloc] initWithData:[@"Hello World" dataUsingEncoding:NSUTF8StringEncoding]] autorelease];

    STAssertFalse(theScanner.isAtEnd, NULL);

    NSString *theString = NULL;
    BOOL theResult = 

    theResult = [theScanner scanString:@"Hello" intoString:&theString];
    STAssertTrue(theResult, NULL);
    STAssertEqualObjects(theString, @"Hello", NULL);
    STAssertEquals((int)theScanner.scanLocation, 5, NULL);

    theResult = [theScanner scanCharacter:' '];
    STAssertTrue(theResult, NULL);
    STAssertEquals((int)theScanner.scanLocation, 6, NULL);

    theResult = [theScanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&theString];
    STAssertTrue(theResult, NULL);
    STAssertEqualObjects(theString, @"World", NULL);
    STAssertEquals((int)theScanner.scanLocation, 11, NULL);


    STAssertTrue(theScanner.isAtEnd, NULL);

    }

@end
