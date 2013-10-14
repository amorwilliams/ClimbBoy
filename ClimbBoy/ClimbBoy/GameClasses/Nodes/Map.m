//
//  Dungeon.m
//  ClimbBoy
//
//  Created by Robin on 13-10-7.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Map.h"
#import "GameManager.h"

@implementation Map

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
        _maxDepth = 5;
        
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

- (void)flagCellAsUnvisited:(CGPoint)point
{
    NSAssert(![self pointIsOutsideBounds:point], @"Point is outside of Map bounds");
    
    if (![self cellWithPoint:point]) {
        _grid[(int)point.x][(int)point.y] = NO;
        [_visitedCells removeObject:[NSValue valueWithCGPoint:point]];
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
    NSAssert(![self rectIsOutsideBounds:rect], @"The rect is outside bounds when flag Rect Cells");
    
    for (int x = (int)rect.origin.x; x < (int)(rect.origin.x + rect.size.width); x++) {
        for (int y = (int)rect.origin.y; y < (int)(rect.origin.y + rect.size.height); y++) {
            [self flagCellAsVisited:CGPointMake(x, y)];
        }
    }
}

- (void)flagRectCellsAsUnvisited:(CGRect)rect
{
    NSAssert(![self rectIsOutsideBounds:rect], @"The rect is outside bounds when flag Rect Cells");
    
    for (int x = (int)rect.origin.x; x < (int)(rect.origin.x + rect.size.width); x++) {
        for (int y = (int)rect.origin.y; y < (int)(rect.origin.y + rect.size.height); y++) {
            [self flagCellAsUnvisited:CGPointMake(x, y)];
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

- (void)addRoom:(Room *)room
{
    NSLog(@"add one room:%@", room.name);
    [self flagRectCellsAsVisited:room.bounds];
    [_rooms addObject:room];
}

- (void)removeRoom:(Room *)room
{
    NSLog(@"remove one room:%@", room.name);
    for (Room *child in _rooms) {
        if ([child.parent isEqual:room]) {
            [self removeRoom:child];
        }
    }
    [self flagRectCellsAsUnvisited:room.bounds];
    [_rooms removeObject:room];
}

- (void)generateWithRootRoom:(Room *)room
{
    //1.创建初始房间 d=0
    //2.获取房间出口
    //3.创建第新房间 d=1
    while (room.depth <= _maxDepth) {
        for (int i = 0; i < room.gates.count; i++) {
            //4.获取房间出口， 判断如果出口没有被连接， 那么创建新房间 d++
            RoomGate *gate = [room.gates objectAtIndex:i];
            
            if (!gate.connectedRoom)
            {
                //5.反复4步骤， 如果房间的d>=n，则创建最后一个单入口房间
                BOOL endRoom = NO;
                if (room.depth >= _maxDepth - 1) {
                    endRoom = YES;
                }
                else {
                    if([self distanceToBoundsFromGate:gate] < 8) {
                        endRoom = YES;
                    }
                }
                
                Room *randomRoom = [self randomRoomFromRoom:room withGate:gate end:endRoom];
                
                if (randomRoom) {
                    [self addRoom:randomRoom];
                    room = randomRoom;
                    break;
                }
                else { //如果房间没有成功创建 说明：1.出口超出map的范围 2.出口所对应的空间不足 无法创建
                    gate.connectedRoom = room; //增加处理逻辑,暂时标记为自身房间。
                }
            }
        }
        
        if ([room allGateConnected]) {
            //6.如果当前房间的所有出口都被连接，则放回上一级，反复4，5步骤
            if (room.parent) {
                room = room.parent;
                NSLog(@"back to room:%@", room.name);
            }
            else {
                //7.如果所有房间的出口都被连接 或者 房间总数量>=m, 则停止创建
                if (room.isRoot) break;
            }
        }
    }
    
    //8.检查房间的链接状况，并根据房间当前需要替换房间类型。
//    [self detectConnectedRoom];
    int iteration = 0;
    while (![self detectConnectedRoom] && (iteration < 300)) {
        iteration++;
    }
}

- (Room *)randomRoomFromRoom:(Room *)room withGate:(RoomGate *)gate end:(BOOL)isEnd
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
    
    CGPoint connectGatePosition = ccpAdd([room cellWorldPositionFromGate:gate], dirOffset) ;
//    NSAssert(![self pointIsOutsideBounds:connectGatePosition], @"The connect gate point is outside bounds.");
    //如果新房间的连接门在地图范围外，那么从父级别房间重新创建房间，并且要求新房间不包含当前的方向的出入口。
    
    if ([self pointIsOutsideBounds:connectGatePosition]) {
        return nil;
    }
    
    NSMutableArray *maps = [NSMutableArray arrayWithArray:[GameManager sharedGameManager].maps];
    //Not use the first room;
    [maps removeObjectAtIndex:0];
    
    while (maps.count)
    {
        int index = arc4random()%maps.count;
        NSDictionary *roomData = [NSDictionary dictionaryWithDictionary:[maps objectAtIndex:index]];
        
        //检查出入口方向
        NSString *checkDir = [roomData valueForKey:@"Gates"];
        if ([checkDir rangeOfString:requireChar].location == NSNotFound) {
            [maps removeObjectAtIndex:index];
            continue;
        }
        
        //检测与相邻房间，两者不为同一种房间
        NSString *tmxFile = [roomData valueForKey:@"Tilemap"];
        if ([room.name isEqualToString:[tmxFile stringByDeletingPathExtension]]) {
            [maps removeObjectAtIndex:index];
            continue;
        }
        
        //创建新房间
        Room* newRoom = [Room roomWithTilemapOfFile:tmxFile parent:room];
        
        if (isEnd) { //如果为最后房间的单入口房间，则检查所创建房间的出入口数量应该为1
            if (newRoom.gates.count > 1){
                [maps removeObjectAtIndex:index];
                continue;
            }
        }
        else { //如果不是单入口房间，则房间出入口应该大于1
            if (newRoom.gates.count < 2){
                [maps removeObjectAtIndex:index];
                continue;
            }
            
            //为了减少1X1房间的数量
//            if ((arc4random()% 11 * 0.1 > 0.5) && (newRoom.width == 1 && newRoom.height == 1)) {
//                [maps removeObjectAtIndex:index];
//                continue;
//            }
        }
        
        //为了保证在生成房间的早期，跟多地产生分支。
//        if(newRoom.depth <= _maxDepth / 2) {
//            if (newRoom.gates.count < 3){
//                [maps removeObjectAtIndex:index];
//                continue;
//            }
//        }

        //遍历新创建房间的所有出入口
        
        NSMutableArray *canMatchGates = [NSMutableArray array];
        for (RoomGate *g in newRoom.gates) {
            if (g.direction == requireDirection) {
                [canMatchGates addObject:g];
            }
        }
    
        RoomGate *connectGate = [canMatchGates objectAtIndex:(arc4random()%canMatchGates.count)];
        
        [newRoom setPosition:ccpSub(connectGatePosition, connectGate.cell)];
        
        if (![self rectIsOutsideBounds:newRoom.bounds])
        {
            if (![self isContainVisitedWithRect:newRoom.bounds])
            {
                //标记相连房间
                connectGate.connectedRoom = room;
                gate.connectedRoom = newRoom;
                return newRoom;
            }
        }
/*
        for (int i = 0; i < newRoom.gates.count; i++) {
            RoomGate *connectGate = [newRoom.gates objectAtIndex:i];
            
            if (connectGate.direction == requireDirection)
            {
                //设置新房间的位置
                [newRoom setPosition:ccpSub(connectGatePosition, connectGate.cell)];
                
                if (![self rectIsOutsideBounds:newRoom.bounds])
                {
                    if (![self isContainVisitedWithRect:newRoom.bounds])
                    {
                        //标记相连房间
                        connectGate.connectedRoom = room;
                        gate.connectedRoom = newRoom;
                        return newRoom;
                    }
                }
            }
        }
 */
        
        [maps removeObjectAtIndex:index];
    }
    
    return nil;
}

- (BOOL)detectConnectedRoom
{
    for (int i = 0; i < _rooms.count; i++) {
        Room *room = [_rooms objectAtIndex:i];
        
        for (int j = 0; j < room.gates.count; j++) {
            RoomGate *gate = [room.gates objectAtIndex:j];
            
            if ([gate.connectedRoom isEqual:gate.room]) {
                NSLog(@"not all connected : %@, %d", room.name, room.depth);
                
                BOOL fixed = NO;
                //尝试替换出入口另一边的相邻房间，使之能够匹配
                GDirctionType requireDirection = kGDirctionNorth;
                CGPoint dirOffset = CGPointZero;
                switch (gate.direction) {
                    default:
                    case kGDirctionNorth:
                        requireDirection = kGDirctionSouth;
                        dirOffset = CGPointMake(0, 1);
                        break;
                    case kGDirctionSouth:
                        requireDirection = kGDirctionNorth;
                        dirOffset = CGPointMake(0, -1);
                        break;
                    case kGDirctionWest:
                        requireDirection = kGDirctionEast;
                        dirOffset = CGPointMake(-1, 0);
                        break;
                    case kGDirctionEast:
                        requireDirection = kGDirctionWest;
                        dirOffset = CGPointMake(1, 0);
                        break;
                }
                
                //获得相邻房间
                CGPoint requireGatePoint = ccpAdd([room cellWorldPositionFromGate:gate], dirOffset);
                Room *adjacentRoom = [self roomFromCell:requireGatePoint];
                if (!adjacentRoom.isRoot)
                {
                    NSLog(@"adjacentRoom : %@, %d", adjacentRoom.name, adjacentRoom.depth);
                    NSMutableArray *maps = [NSMutableArray arrayWithArray:[GameManager sharedGameManager].maps];
                    [maps removeObjectAtIndex:0];
                    
                    while (maps.count)
                    {
                        int index = arc4random()%maps.count;
                        NSDictionary *roomData = [NSDictionary dictionaryWithDictionary:[maps objectAtIndex:index]];
                        
                        //创建新房间
                        NSString *tmxFile = [roomData valueForKey:@"Tilemap"];
                        Room* newRoom = [Room roomWithTilemapOfFile:tmxFile parent:adjacentRoom.parent];
                        [newRoom setPosition:adjacentRoom.position];
                        
                        //匹配大小
                        if (!CGRectEqualToRect(adjacentRoom.bounds, newRoom.bounds)) {
                            [maps removeObjectAtIndex:index];
                            continue;
                        }
                        
                        
                        //匹配数量
                        if (newRoom.gates.count != adjacentRoom.gates.count + 1) {
                            [maps removeObjectAtIndex:index];
                            continue;
                        }
                        
                        //匹配方向
                        NSMutableArray *unmatchGates = [NSMutableArray arrayWithArray:newRoom.gates];
                        for (RoomGate *adjGate in adjacentRoom.gates) {
                            for (RoomGate *newGate in newRoom.gates) {
                                if (CGPointEqualToPoint(newGate.cell, adjGate.cell) &&
                                    newGate.direction == adjGate.direction) {
                                    [unmatchGates removeObject:newGate];
                                }
                            }
                        }
                        
                        if (unmatchGates.count != 1) {
                            [maps removeObjectAtIndex:index];
                            continue;
                        }
                        
                        RoomGate *addedGate = [unmatchGates firstObject];
                        
                        if (addedGate.direction != requireDirection) {
                            [maps removeObjectAtIndex:index];
                            continue;
                        }
                        
                        //匹配位置
                        if (!CGPointEqualToPoint([newRoom cellWorldPositionFromGate:addedGate], requireGatePoint)) {
                            [maps removeObjectAtIndex:index];
                            continue;
                        }
                        
                        //替换原来的房间
                        for (RoomGate *adjGate in adjacentRoom.gates) {
                            RoomGate *connectedGate = [self connectedGateFromGate:adjGate];
                            connectedGate.connectedRoom = newRoom;
                            
                            for (RoomGate *newGate in newRoom.gates) {
                                if (CGPointEqualToPoint(newGate.cell, adjGate.cell) &&
                                    newGate.direction == adjGate.direction) {
                                    newGate.connectedRoom = connectedGate.room;
                                }
                            }
                        }
                        
                        gate.connectedRoom = newRoom;
                        addedGate.connectedRoom = room;
                        
                        [_rooms replaceObjectAtIndex:[_rooms indexOfObject:adjacentRoom] withObject:newRoom];
                        fixed = YES;
                        NSLog(@"Replace adjacent : %@, %d to %@, %d", adjacentRoom.name, adjacentRoom.depth, newRoom.name, newRoom.depth);
                        break;
                    }
                }
                
                if (!fixed)
                {
                    //找不到匹配房间，那么就替换自己
                    NSLog(@"UnFound match adjacent room to change: %@, %d", adjacentRoom.name, adjacentRoom.depth);
                    
                    NSMutableArray *maps = [NSMutableArray arrayWithArray:[GameManager sharedGameManager].maps];
                    [maps removeObjectAtIndex:0];
                    
                    while (maps.count)
                    {
                        int index = arc4random()%maps.count;
                        NSDictionary *roomData = [NSDictionary dictionaryWithDictionary:[maps objectAtIndex:index]];
                        
                        //创建新房间
                        NSString *tmxFile = [roomData valueForKey:@"Tilemap"];
                        Room* newRoom = [Room roomWithTilemapOfFile:tmxFile parent:room.parent];
                        [newRoom setPosition:room.position];
                        
                        //匹配大小
                        if (!CGRectEqualToRect(room.bounds, newRoom.bounds)) {
                            [maps removeObjectAtIndex:index];
                            continue;
                        }
                        
                        
                        //匹配数量
                        if (newRoom.gates.count != room.gates.count - 1) {
                            [maps removeObjectAtIndex:index];
                            continue;
                        }
                        
                        //匹配方向
                        NSMutableArray *unmatchGates = [NSMutableArray arrayWithArray:newRoom.gates];
                        for (RoomGate *adjGate in room.gates) {
                            if ([adjGate.connectedRoom isEqual:room]) {
                                continue;
                            }
                            
                            for (RoomGate *newGate in newRoom.gates) {
                                if (CGPointEqualToPoint(newGate.cell, adjGate.cell) &&
                                    newGate.direction == adjGate.direction)
                                {
                                    [unmatchGates removeObject:newGate];
                                }
                            }
                        }
                        
                        if (unmatchGates.count != 0) {
                            [maps removeObjectAtIndex:index];
                            continue;
                        }
                        
                        //替换原来的房间
                        for (RoomGate *adjGate in room.gates) {
                            for (RoomGate *newGate in newRoom.gates) {
                                if (CGPointEqualToPoint(newGate.cell, adjGate.cell) &&
                                    newGate.direction == adjGate.direction) {
                                    RoomGate *connectedGate = [self connectedGateFromGate:adjGate];
                                    connectedGate.connectedRoom = newRoom;
                                    newGate.connectedRoom = connectedGate.room;
                                }
                            }
                        }
                        
//                        gate.connectedRoom = newRoom;
//                        addedGate.connectedRoom = room;
                        
                        [_rooms replaceObjectAtIndex:[_rooms indexOfObject:room] withObject:newRoom];
                        fixed = YES;
                        NSLog(@"Replace self : %@, %d to %@, %d", room.name, room.depth, newRoom.name, newRoom.depth);
                        break;
                    }
                }
                
                if (!fixed) {
                    NSLog(@"UnFound match room to fix: %@, %d", room.name, room.depth);
                }
                
                return NO;
            }
        }
    }
    
    return YES;
}

/*
- (BOOL)replaceRoom:(Room *)room withGateCount:(NSInteger)gateCount gateDirection:(GDirctionType)gateDirection gatePosition:(CGPoint)gatePosition
{
    
    NSMutableArray *maps = [NSMutableArray arrayWithArray:[GameManager sharedGameManager].maps];
    [maps removeObjectAtIndex:0];
    
    while (maps.count)
    {
        int index = arc4random()%maps.count;
        NSDictionary *roomData = [NSDictionary dictionaryWithDictionary:[maps objectAtIndex:index]];
        
        //创建新房间
        NSString *tmxFile = [roomData valueForKey:@"Tilemap"];
        Room* newRoom = [Room roomWithTilemapOfFile:tmxFile parent:room.parent];
        [newRoom setPosition:room.position];
        
        //匹配大小
        if (!CGRectEqualToRect(room.bounds, newRoom.bounds)) {
            [maps removeObjectAtIndex:index];
            continue;
        }
        
        
        //匹配数量
        if (newRoom.gates.count != gateCount) {
            [maps removeObjectAtIndex:index];
            continue;
        }
        
        //匹配方向
        NSMutableArray *newGates = [NSMutableArray arrayWithArray:newRoom.gates];
        for (RoomGate *gate in room.gates) {
            for (RoomGate *newGate in newRoom.gates) {
                if (CGPointEqualToPoint(newGate.cell, gate.cell) &&
                    newGate.direction == gate.direction) {
                    [newGates removeObject:newGate];
                }
            }
        }
        
        if (newGates.count != 1) {
            [maps removeObjectAtIndex:index];
            continue;
        }
        
        RoomGate *addedGate = [newGates firstObject];
        
        if (addedGate.direction != gateDirection) {
            [maps removeObjectAtIndex:index];
            continue;
        }
        
        //匹配位置
        if (!CGPointEqualToPoint([newRoom cellWorldPositionFromGate:addedGate], gatePosition)) {
            [maps removeObjectAtIndex:index];
            continue;
        }
        
        //替换原来的房间
        for (RoomGate *adjGate in room.gates) {
            RoomGate *connectedGate = [self connectedGateFromGate:adjGate];
            connectedGate.connectedRoom = newRoom;
            
            for (RoomGate *newGate in newRoom.gates) {
                if (CGPointEqualToPoint(newGate.cell, adjGate.cell) &&
                    newGate.direction == adjGate.direction) {
                    newGate.connectedRoom = connectedGate.room;
                }
            }
        }
        
        gate.connectedRoom = newRoom;
        addedGate.connectedRoom = room;
        
        [_rooms replaceObjectAtIndex:[_rooms indexOfObject:room] withObject:newRoom];
        return YES;
    }
    
    return NO;
}
 */

- (RoomGate *)roomGateFromGatePoint:(CGPoint)point inDirection:(GDirctionType)direction;
{
    for (Room *room in _rooms) {
        for (RoomGate *gate in room.gates) {
            if (CGPointEqualToPoint(gate.cell, point) &&
                gate.direction == direction) {
                return gate;
            }
        }
    }
    return nil;
}

- (Room *)roomFromCell:(CGPoint)point
{
    if (![self cellWithPoint:point]) {
        return nil;
    }
    
    for (Room *room in _rooms) {
        if (CGRectContainsPoint(room.bounds, point)) {
            return room;
        }
    }
    return nil;
}

- (NSInteger)distanceToBoundsFromGate:(RoomGate *)gate
{
    CGPoint gateWorldPos = ccpAdd(gate.room.position, gate.cell);
    switch (gate.direction) {
        case kGDirctionNorth:
            return self.height - gateWorldPos.y - 1;
        case kGDirctionSouth:
            return gateWorldPos.y;
        case kGDirctionWest:
            return gateWorldPos.x;
        case kGDirctionEast:
            return self.width - gateWorldPos.x - 1;
    }
}

- (RoomGate *)connectedGateFromGate:(RoomGate *)gate
{
    for (RoomGate *aGate in gate.connectedRoom.gates) {
        if ([aGate.connectedRoom isEqual:gate.room]) {
            return aGate;
        }
    }
    
    NSAssert(NO, @"Can not find connected gate form gate in room:%@", gate.room.name);
    return nil;
}

@end





