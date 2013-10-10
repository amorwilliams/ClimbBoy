//
//  Room.m
//  ClimbBoy
//
//  Created by Robin on 13-10-7.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Room.h"
#import "GameManager.h"

@implementation RoomGate

@end

@implementation Room

+ (id)roomWithTilemapOfFile:(NSString *)tmxFile parent:(Room *)parentRoom
{
    return [[[self class] alloc] initWithTilemapOfFile:tmxFile parent:parentRoom];
}

- (id)initWithTilemapOfFile:(NSString *)tmxFile parent:(Room *)parentRoom
{
    for (NSDictionary *room in [GameManager sharedGameManager].maps) {
        NSString *tmx = [room valueForKey:@"Tilemap"];
        if ([tmx isEqualToString:tmxFile]) {
            _roomData = [NSDictionary dictionaryWithDictionary:room];
            break;
        }
    }
    NSAssert(_roomData, @"Can not find room data from %@ file", tmxFile);

//    _tilemapNode = [KKTilemapNode tilemapWithContentsOfFile:tmxFile];
//    KKTilemap *tilemap = _tilemapNode.tilemap;
    int width = [[_roomData valueForKey:@"Width"] intValue] / kCell_Width;
    int height = [[_roomData valueForKey:@"Height"] intValue] / kCell_Height;
    
    self = [super initWithWidth:width height:height];
    if (self) {
        _name = [tmxFile stringByDeletingPathExtension];
        _parent = parentRoom;
        if (!_parent) {
            _isRoot = YES;
            _depth = 0;
        }
        else {
            _isRoot = NO;
            _depth = _parent.depth + 1;
        }
        
        [self markAllCellsvisited];
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    
//    KKTilemapProperties *mapProperties = _tilemapNode.tilemap.properties;
    NSString *gatesString = [_roomData valueForKey:@"Gates"];
    
    NSArray *gatesStringArray = [gatesString componentsSeparatedByString:@"-"];
    gatesStringArray = [gatesStringArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    
    NSMutableArray *gates = [NSMutableArray array];
    for (NSString *gate in gatesStringArray) {
        NSString *firstChar = [gate substringToIndex:1];
        int index = [[gate substringFromIndex:1] intValue];
        
        RoomGate *roomGate;
        if ([firstChar isEqualToString:@"N"]) {
            roomGate = [self gateByIndex:index inDirection:kGDirctionNorth];
        }
        else if ([firstChar isEqualToString:@"S"]) {
            roomGate = [self gateByIndex:index inDirection:kGDirctionSouth];
        }
        else if ([firstChar isEqualToString:@"W"]) {
            roomGate = [self gateByIndex:index inDirection:kGDirctionWest];
        }
        else if ([firstChar isEqualToString:@"E"]) {
            roomGate = [self gateByIndex:index inDirection:kGDirctionEast];
        }
        
        [gates addObject:roomGate];
    }
    
    _gates = [NSArray arrayWithArray:gates];
}

- (RoomGate *) gateByIndex:(int)index inDirection:(GDirctionType)direction
{
    RoomGate *roomGate = [RoomGate new];
    roomGate.direction = direction;
    
    switch (direction) {
        case kGDirctionNorth:
            roomGate.cell = CGPointMake(index-1, self.height - 1);
            break;
        case kGDirctionSouth:
            roomGate.cell = CGPointMake(index-1, 0);
            break;
        case kGDirctionWest:
            roomGate.cell = CGPointMake(0, self.height - index);
            break;
        case kGDirctionEast:
            roomGate.cell = CGPointMake(self.width - 1, self.height - index);
            break;
        default:
            break;
    }
    
    NSAssert(![self pointIsOutsideBounds:roomGate.cell], @"Gate Point is Outside Bounds in room data : %@", self.name);
    
    roomGate.room = self;
    return roomGate;
//    [_gates addObject:roomGate];
}

- (void)markAllCellsvisited
{
    for (int x = 0; x < self.width; x++) {
        for (int y = 0; y < self.height; y++) {
            _grid[x][y] = YES;
        }
    }
}

-(void)setPosition:(CGPoint)position
{
    _bounds.origin.x = position.x;
    _bounds.origin.y = position.y;
}

- (CGPoint)position
{
    return CGPointMake(_bounds.origin.x, _bounds.origin.y);
}

- (BOOL)hasGateByDirection:(GDirctionType)direction
{
    for (RoomGate *gate in _gates) {
        if (gate.direction == direction) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)allGateConnected
{
    for (RoomGate *gate in _gates) {
        if (!gate.connectedRoom) {
            return NO;
        }
    }
    return YES;
}

- (CGPoint)cellWorldPositionFromGate:(RoomGate *)gate
{
    return ccpAdd(_bounds.origin, gate.cell);
}

- (void)setDepth:(uint8_t)depth
{
    _depth = depth;
}

@end
