//
//  ClimbBoy_iOS_Tests.m
//  ClimbBoy-iOS Tests
//
//  Created by Robin on 13-10-6.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Dungeon.h"
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
    Dungeon *map = [Dungeon dungeonWithWidth:20 height:20];
    
    [map flagRectCellsAsVisited:CGRectMake(3, 2, 5, 5)];
    [map flagRectCellsAsVisited:CGRectMake(6, 8, 10, 4)];
    
    NSLog(@"%@", [map description]);
}

- (void)testGetRandomVisitedCell
{
    Dungeon *map = [Dungeon dungeonWithWidth:10 height:10];
    
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
    Room *room = [Room roomWithTilemapOfFile:@"Level01.tmx"];
    
    NSLog(@"%@", [room description]);
    
    for (int i = 0; i < room.gates.count; i++) {
        RoomGate *gate = [RoomGate new];
        [[room.gates objectAtIndex:i] getValue:&gate];
        NSLog(@"%d, %d, direction: %d", (int)gate.cell.x, (int)gate.cell.y, (int)gate.direction);
    }
}

- (void)testRandomRoom
{
    Dungeon *map = [Dungeon dungeonWithWidth:20 height:20];
    
    Room *room = [Room roomWithTilemapOfFile:@"Level01.tmx"];
    [room setPosition:CGPointMake(0, 9)];
    [map addRoom:room];
    
    RoomGate *gate = [RoomGate new];
    gate.cell = CGPointMake(3, 1);
    gate.direction = kGDirctionEast;
    Room *randomRoom = [map randomRoomFromRoom:room withGate:gate];
    [map addRoom:randomRoom];
    
    NSLog(@"%@", [map description]);
}



@end
