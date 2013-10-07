//
//  Dungeon.h
//  ClimbBoy
//
//  Created by Robin on 13-10-7.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Map.h"
#import "Room.h"

@interface Dungeon : Map
{
    NSMutableArray *_visitedCells;
}

@property (nonatomic, readonly) NSMutableArray *rooms;

+ (id) dungeonWithWidth:(int)width height:(int)height;

- (CGPoint) pickRandomCellAndMarkItVisited;
- (BOOL) isVisitedWithAdjacentCell:(CGPoint)point inDirection:(GDirctionType)direction;
- (void) flagCellAsVisited:(CGPoint)point;
- (BOOL) isContainVisitedWithRect:(CGRect)rect;
- (void) flagRectCellsAsVisited:(CGRect)rect;


- (CGPoint) randomVisitedCell;
//The method then picks a random index within the bounds of the visited cells list. It picks a new index until the visited cell is different than the cell passed in a input parameter and returns this cell.
- (CGPoint) randomVisitedCellExclude:(CGPoint)point;

- (void) addRoom:(Room *)room;
- (Room *) randomRoomFromRoom:(Room *)room withGate:(RoomGate *)gate;


@end
