//
//  ClimbBoy_iOS_Tests.m
//  ClimbBoy-iOS Tests
//
//  Created by Robin on 13-9-22.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GameData.h"

@interface ClimbBoy_iOS_Tests : XCTestCase

@end

@implementation ClimbBoy_iOS_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    GameData *data = [GameData sharedGameData];
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
