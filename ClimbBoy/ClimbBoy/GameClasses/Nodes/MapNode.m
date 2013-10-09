//
//  MapGenerator.m
//  ClimbBoy
//
//  Created by Robin on 13-10-6.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "MapNode.h"

@implementation MapNode


- (void)generate
{
    _map = [Map dungeonWithWidth:20 height:20];
    _map.maxDepth = 3;
    
//    Room *newRoom = [Room roomWithTilemapOfFile:@"Level01.tmx" parent:nil];
//    [newRoom setPosition:CGPointMake(0, 9)];
//    [_map addRoom:newRoom];
//    Room *randomRoom = [_map randomRoomFromRoom:newRoom withGate:[newRoom.gates firstObject] end:NO];
//    [_map addRoom:randomRoom];
    
    Room *newRoom = [Room roomWithTilemapOfFile:@"Level01.tmx" parent:nil];
    [newRoom setPosition:CGPointMake(2, 9)];
    [_map addRoom:newRoom];
    [_map generateWithParentRoom:newRoom];
    
    NSLog(@"%@", [_map description]);
    
    const int factor = 4;
    
    //add map bounds
    CGRect bounds = CGRectMake(_map.bounds.origin.x,
                               _map.bounds.origin.y,
                               _map.bounds.size.width * 12 * factor,
                               _map.bounds.size.height * 6 *factor);
    CGPathRef mPath = CGPathCreateWithRect(bounds, NULL);
    SKShapeNode *mShape = [SKShapeNode node];
    mShape.path = mPath;
    mShape.antialiased = NO;
    mShape.lineWidth = 1;
    mShape.fillColor = [SKColor blackColor];
    mShape.glowWidth = 2;
    mShape.strokeColor = [SKColor colorWithRed:0.4 green:0.8 blue:1 alpha:1];
    [self addChild:mShape];
    CGPathRelease(mPath);
    
    //add rooms bounds and gate
    for (Room * room in _map.rooms) {
        CGRect rect = room.bounds;
        rect = CGRectMake(rect.origin.x * 12 * factor + 2,
                          rect.origin.y * 6 * factor + 2,
                          rect.size.width * 12 * factor - 4,
                          rect.size.height * 6 * factor - 4);
        
        CGPathRef path = CGPathCreateWithRect(rect, NULL);
        SKShapeNode *shape = [SKShapeNode node];
        shape.path = path;
        shape.antialiased = NO;
        shape.lineWidth = 1;
//        shape.glowWidth = 2;
        shape.blendMode = SKBlendModeAdd;
        shape.strokeColor = [SKColor colorWithRed:0.4 green:0.4 blue:1 alpha:1];
        shape.fillColor = [SKColor colorWithRed:0.4 green:0.4 blue:1 alpha:0.3];
        [self addChild:shape];
        CGPathRelease(path);
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
		label.text = [NSString stringWithFormat:@"%@ : %d", room.name, room.depth];
		label.fontSize = 6;
		label.position = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        label.alpha = 1;
		[self addChild:label];
        
        for (RoomGate *gate in room.gates) {
            BOOL connected = ![gate.connectedRoom isEqual:room];
            SKSpriteNode *gateNode = [SKSpriteNode spriteNodeWithColor:(connected ? [SKColor cyanColor] : [SKColor redColor])
                                                                  size:CGSizeMake(factor/2.0, factor/2.0)];
            gateNode.anchorPoint = ccp(0.5, 0.5);
            CGPoint p = ccpAdd(room.position, gate.cell);
            switch (gate.direction) {
                case kGDirctionNorth:
                    p = ccp(p.x + 0.5, p.y + 1);
                    p = ccp(p.x * 12 * factor, p.y * 6 * factor - 1);
                    break;
                case kGDirctionSouth:
                    p = ccp(p.x + 0.5, p.y);
                    p = ccp(p.x * 12 * factor, p.y * 6 * factor + 1);
                    break;
                case kGDirctionWest:
                    p = ccp(p.x, p.y + 0.5);
                    p = ccp(p.x * 12 * factor + 1, p.y * 6 * factor);
                    break;
                case kGDirctionEast:
                    p = ccp(p.x + 1, p.y + 0.5);
                    p = ccp(p.x * 12 * factor - 1, p.y * 6 * factor);
                default:
                    break;
            }
            gateNode.position = p;
            [self addChild:gateNode];
        }
    }
}

@end
