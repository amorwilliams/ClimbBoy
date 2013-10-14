//
//  RoomNode.h
//  ClimbBoy
//
//  Created by Robin on 13-10-12.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Room.h"

@interface RoomNode : KKNode

@property (nonatomic) Room *room;
@property (nonatomic, readonly)KKTilemapNode *tilemapNode;
@property (nonatomic) BOOL enable;
@property (nonatomic, readonly)CGVector gravity;

+ (id) roomWithRoom:(Room *)room;

@end
