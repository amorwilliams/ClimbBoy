//
//  Dungeon.m
//  ClimbBoy
//
//  Created by Robin on 13-10-7.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Dungeon.h"
#import "GameManager.h"

@implementation Dungeon

+ (id)dungeonWithWidth:(int)width height:(int)height
{
    return [[[self class] alloc] initWithWidth:width height:height];
}

- (id)initWithWidth:(int)width height:(int)height
{
    self = [super initWithWidth:width height:height];
    if (self) {
        _visitedCells = [NSMutableArray arrayWithCapacity:2];
        _rooms = [NSMutableArray arrayWithCapacity:2];
        
        [self markCellsUnvisited];
    }
    return self;
}

- (void)markCellsUnvisited
{
    for (int x = 0; x < self.width; x++) {
        for (int y = 0; y < self.height; y++) {
            _grid[x][y] = NO;
        }
    }
}

- (CGPoint)pickRandomCellAndMarkItVisited
{
    CGPoint p = CGPointMake(arc4random() % self.width, arc4random() % self.height);
    _grid[(int)p.x][(int)p.y] = YES;
    return p;
}
- (BOOL)isVisitedWithAdjacentCell:(CGPoint)point inDirection:(GDirctionType)direction
{
    NSAssert([self hasAdjacentCell:point inDirection:direction], @"No adjacent cell exists for the point and direction provided.");
    
    switch(direction)
    {
        case kGDirctionNorth:
            return _grid[(int)point.x][(int)point.y-1];
        case kGDirctionSouth:
            return _grid[(int)point.x-1][(int)point.y];
        case kGDirctionWest:
            return _grid[(int)point.x][(int)point.y+1];
        case kGDirctionEast:
            return _grid[(int)point.x+1][(int)point.y];
        default:
            return NO;
    }
}

- (void)flagCellAsVisited:(CGPoint)point
{
    NSAssert(![self pointIsOutsideBounds:point], @"Point is outside of Map bounds");
    
    if (![self cellWithPoint:point]) {
        _grid[(int)point.x][(int)point.y] = YES;
        [_visitedCells addObject:[NSValue valueWithCGPoint:point]];
    }
}

- (BOOL)isContainVisitedWithRect:(CGRect)rect
{
    NSAssert(![self rectIsOutsideBounds:rect], @"The rect is outside bounds");
    
    for (int x = (int)rect.origin.x; x < (int)(rect.origin.x + rect.size.width); x++) {
        for (int y = (int)rect.origin.y; y < (int)(rect.origin.y + rect.size.height); y++) {
            if (_grid[x][y]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)flagRectCellsAsVisited:(CGRect)rect
{
    NSAssert(![self rectIsOutsideBounds:rect], @"The rect is outside bounds");
    
    for (int x = (int)rect.origin.x; x < (int)(rect.origin.x + rect.size.width); x++) {
        for (int y = (int)rect.origin.y; y < (int)(rect.origin.y + rect.size.height); y++) {
            [self flagCellAsVisited:CGPointMake(x, y)];
        }
    }
}

- (CGPoint)randomVisitedCell
{
    NSAssert(_visitedCells.count > 0, @"There are no visited cells to return.");
    
    int index = arc4random() % _visitedCells.count;
    return [[_visitedCells objectAtIndex:index] CGPointValue];
}

- (CGPoint)randomVisitedCellExclude:(CGPoint)point
{
    NSAssert(_visitedCells.count > 0, @"There are no visited cells to return.");
    
    CGPoint p = [self randomVisitedCell];
    while (CGPointEqualToPoint(p, point)) {
        NSAssert(_visitedCells.count > 1, @"There is only one point and the point is param.");
        p = [self randomVisitedCell];
    }
    
    return p;
}

- (void)generateWithStartRoom:(Room *)startRoom
{
    while (_rooms.count < 8) {
        
    }
}

- (void)addRoom:(Room *)room
{
    [self flagRectCellsAsVisited:room.bounds];
    [_rooms addObject:room];
}

- (Room *)randomRoomFromRoom:(Room *)room withGate:(RoomGate *)gate
{
    GDirctionType requireDirection = kGDirctionNorth;
    NSString *requireChar = @"";
    CGPoint dirOffset = CGPointZero;
    switch (gate.direction) {
        default:
        case kGDirctionNorth:
            requireDirection = kGDirctionSouth;
            requireChar = @"S";
            dirOffset = CGPointMake(0, 1);
            break;
        case kGDirctionSouth:
            requireDirection = kGDirctionNorth;
            requireChar = @"N";
            dirOffset = CGPointMake(0, -1);
            break;
        case kGDirctionWest:
            requireDirection = kGDirctionEast;
            requireChar = @"E";
            dirOffset = CGPointMake(-1, 0);
            break;
        case kGDirctionEast:
            requireDirection = kGDirctionWest;
            requireChar = @"W";
            dirOffset = CGPointMake(1, 0);
            break;
    }
    CGPoint connectGatePosition = ccpAdd(ccpAdd(room.position, gate.cell), dirOffset) ;
    NSAssert(![self pointIsOutsideBounds:connectGatePosition], @"The connect gate point is outside bounds.");
    
    NSMutableArray *maps = [[GameManager sharedGameManager].maps copy];
    Room *randomRoom;
    bool found = NO;
    while (!found && maps.count > 0)
    {
        NSDictionary *roomData = [NSDictionary dictionaryWithDictionary:[maps objectAtIndex:(arc4random()%maps.count)]];
        NSString *checkChar = [roomData valueForKey:@"Gates"];
        if ([checkChar rangeOfString:requireChar].location == NSNotFound) {
            [maps removeObject:roomData];
            continue;
        }
        
        NSString *tmxFile = [roomData valueForKey:@"Tilemap"];
        if ([room.name isEqualToString:[tmxFile stringByDeletingPathExtension]]) {
            [maps removeObject:roomData];
            continue;
        }
        
        randomRoom = [Room roomWithTilemapOfFile:tmxFile];
        
        NSMutableArray *tempGates = [NSMutableArray arrayWithArray:randomRoom.gates];
        while (tempGates.count > 0) {
            int index = arc4random()%tempGates.count;
            RoomGate *connectGate = [tempGates objectAtIndex:index];
            
            if (connectGate.direction == requireDirection) {
                //random room world position
                [randomRoom setPosition:ccpSub(connectGatePosition, connectGate.cell)];
                
                //if cover others then continue
                if ([self rectIsOutsideBounds:randomRoom.bounds]) {
                    break;
                }
                else {
                    if ([self isContainVisitedWithRect:randomRoom.bounds]) {
                        [tempGates removeObjectAtIndex:index];
                        continue;
                    }
                    else{
                        found = YES;
                        break;
                    }
                }
            }
        }
    }
    
    if (found) {
        return randomRoom;
    }
    
    return nil;
}

@end


















