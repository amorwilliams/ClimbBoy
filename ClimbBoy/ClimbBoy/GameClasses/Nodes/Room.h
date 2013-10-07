//
//  Room.h
//  ClimbBoy
//
//  Created by Robin on 13-10-7.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Map.h"

#define kCell_Width 6
#define kCell_Height 6

//typedef struct RoomGate{
//    CGPoint cell;
//    GDirctionType direction;
//}RoomGate;

@interface RoomGate : NSObject

@property (nonatomic) CGPoint cell;
@property (nonatomic) GDirctionType direction;
@property (nonatomic) BOOL connected;

@end

@interface Room : Map
{
    NSDictionary *_roomData;
}
@property (nonatomic, readonly) NSString *name;
//@property (nonatomic, readonly)KKTilemapNode *tilemapNode;
@property (nonatomic) CGPoint position;
@property (nonatomic, readonly) NSMutableArray *gates;

+ (id) roomWithTilemapOfFile:(NSString *)tmxFile;
- (id) initWithTilemapOfFile:(NSString *)tmxFile;

@end
