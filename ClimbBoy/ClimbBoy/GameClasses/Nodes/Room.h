//
//  Room.h
//  ClimbBoy
//
//  Created by Robin on 13-10-7.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Grid.h"

#define kCell_Width 12
#define kCell_Height 6

//typedef struct RoomGate{
//    CGPoint cell;
//    GDirctionType direction;
//}RoomGate;

@class Room;
@interface RoomGate : NSObject

@property (nonatomic) CGPoint cell;
@property (nonatomic) GDirctionType direction;
@property (nonatomic, weak) Room *room;
@property (nonatomic, weak) Room *connectedRoom;

@end

@interface Room : Grid
{
    NSDictionary *_roomData;
}
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) BOOL isRoot;
@property (nonatomic, readonly) Room *parent;
@property (nonatomic, readonly) uint8_t depth;
//@property (nonatomic, readonly)KKTilemapNode *tilemapNode;
@property (nonatomic) CGPoint position;
@property (nonatomic, readonly) NSMutableArray *gates;

+ (id) roomWithTilemapOfFile:(NSString *)tmxFile parent:(Room *)parentRoom;
- (id) initWithTilemapOfFile:(NSString *)tmxFile parent:(Room *)parentRoom;

- (BOOL) hasGateByDirection:(GDirctionType)direction;
- (BOOL) allGateConnected;
- (CGPoint) cellWorldPositionFromGate:(RoomGate *)gate;

@end
