//
//  ClimbBoy_iOS_Tests.m
//  ClimbBoy-iOS Tests
//
//  Created by Robin on 13-10-6.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Map.h"
#import "Room.h"

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
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testflagRectCells
{
    Map *map = [Map dungeonWithWidth:20 height:20];
    
    [map flagRectCellsAsVisited:CGRectMake(3, 2, 5, 5)];
    [map flagRectCellsAsVisited:CGRectMake(6, 8, 10, 4)];
    
    NSLog(@"%@", [map description]);
}

- (void)testGetRandomVisitedCell
{
    Map *map = [Map dungeonWithWidth:10 height:10];
    
    [map flagCellAsVisited:CGPointMake(1, 0)];
    [map flagCellAsVisited:CGPointMake(2, 5)];
    [map flagCellAsVisited:CGPointMake(8, 4)];
    [map flagCellAsVisited:CGPointMake(4, 2)];
    
    CGPoint p = [map randomVisitedCell];
    NSLog(@"%d,%d", (int)p.x, (int)p.y);
    p = [map randomVisitedCellExclude:p];
    NSLog(@"%d,%d", (int)p.x, (int)p.y);

    NSLog(@"%@", [map description]);
}

- (void)testCreateRoom
{
    Room *room = [Room roomWithTilemapOfFile:@"Level01.tmx" parent:nil];
    
    NSLog(@"%@", [room description]);
    
    for (int i = 0; i < room.gates.count; i++) {
        RoomGate *gate = [room.gates objectAtIndex:i];
        NSLog(@"%d, %d, direction: %d", (int)gate.cell.x, (int)gate.cell.y, (int)gate.direction);
    }
}

- (void)testRandomRoom
{
    Map *map = [Map dungeonWithWidth:20 height:20];
    
    Room *room = [Room roomWithTilemapOfFile:@"Level01.tmx" parent:nil];
    [room setPosition:CGPointMake(0, 9)];
    [map addRoom:room];
    
    Room *randomRoom = [map randomRoomFromRoom:room withGate:[room.gates firstObject] end:NO];
    [map addRoom:randomRoom];
    
    NSLog(@"%@", [map description]);
}

- (void)testGenerate
{
    Map *map = [Map dungeonWithWidth:20 height:20];
    
    Room *room = [Room roomWithTilemapOfFile:@"Level01.tmx" parent:nil];
    [room setPosition:CGPointMake(0, 9)];
    [map addRoom:room];
    
    [map generateWithParentRoom:room];
    
    NSLog(@"%@", [map description]);
}



@end
