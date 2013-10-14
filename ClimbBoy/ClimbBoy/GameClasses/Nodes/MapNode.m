//
//  MapGenerator.m
//  ClimbBoy
//
//  Created by Robin on 13-10-6.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "MapNode.h"

@implementation MapNode

+ (id)MapWithGridSize:(CGSize)gridSize
{
    return [[[self class] alloc] initWithGridSize:gridSize];
}

- (id)initWithGridSize:(CGSize)gridSize
{
    self = [super init];
    if (self) {
        _gridSize = gridSize;
        [self generate];
        //生成随机地图数据
        //创建tilemap model
        //合并tilemap
    }
    return self;
}

- (void)generate
{
//    Room *newRoom = [Room roomWithTilemapOfFile:@"Level01.tmx" parent:nil];
//    [newRoom setPosition:CGPointMake(0, 9)];
//    [_map addRoom:newRoom];
//    Room *randomRoom = [_map randomRoomFromRoom:newRoom withGate:[newRoom.gates firstObject] end:NO];
//    [_map addRoom:randomRoom];
    
    
    int roomCount = 0;
//    while (roomCount < 15 || roomCount > 30) {
        _map = [Map dungeonWithWidth:20 height:20];
        _map.maxDepth = 6;
        Room *newRoom = [Room roomWithTilemapOfFile:@"room_root.tmx" parent:nil];
        [newRoom setPosition:CGPointMake(0, 0)];
        [_map addRoom:newRoom];
        [_map generateWithRootRoom:newRoom];
        roomCount = _map.rooms.count;
        NSLog(@"rooms count: %d", roomCount);
//    }
    
    NSLog(@"%@", [_map description]);
    
    
    //Combine all tilemaps to a mainTilemap
    //Create a big mainTilemap
    CGSize mapSize = CGSizeMake(_map.width * kCell_Width, _map.height * kCell_Height);
    CGSize gridSize = CGSizeMake(64, 64);
    _mainTilemap = [KKTilemap tilemapWithOrientation:KKTilemapOrientationOrthogonal mapSize:mapSize gridSize:gridSize];
    
    NSMutableArray *tilemaps = [NSMutableArray array];
    for (Room *room in _map.rooms)
    {
        //Read tilemap from tmx
        KKTilemap *tilemap = [KKTilemap tilemapWithContentsOfFile:[NSString stringWithFormat:@"%@.tmx",room.name]];
        [tilemaps addObject:tilemaps];
        
        if (room.isRoot) {
            [_mainTilemap addTileset:[tilemap.tilesets firstObject]];
            
            for (NSString *key in tilemap.properties.properties) {
                [_mainTilemap.properties.properties setValue:[tilemap.properties.properties valueForKey:key] forKey:key];
            }
        }
        
        //
        for (KKTilemapLayer *layer in tilemap.layers)
        {
            if ([layer isTileLayer])
            {
                unsigned int expectedSize = mapSize.width * mapSize.height * sizeof(gid_t);
                gid_t *newgid = (gid_t *)malloc(expectedSize);
                
                for (int tilePosY = 0; tilePosY < layer.size.height ; tilePosY++) {
                    for (int tilePosX = 0; tilePosX < layer.size.width; tilePosX++) {
                        gid_t gid = [layer tileGidWithFlagsAt:CGPointMake(tilePosX, tilePosY)];
                        
                        int tilePosXInOffset = tilePosX + room.position.x * kCell_Width;
                        int tilePosYInOffset = tilePosY + (_map.height - room.position.y - room.height) * kCell_Height;
                        int index = tilePosXInOffset + tilePosYInOffset * mapSize.width;
                        newgid[index] = gid;
                    }
                }
                
                layer.size = mapSize;
                layer.tileCount = mapSize.width * mapSize.height;
                [layer.tiles retainGidBuffer:newgid sizeInBytes:expectedSize];
            }
            else if ([layer isObjectLayer])
            {
                layer.size = mapSize;
                layer.tileCount = mapSize.width * mapSize.height;
                
                for (KKTilemapObject *object in layer.objects) {
                    CGPoint offset = ccp(room.position.x * kCell_Width * gridSize.width, room.position.y * kCell_Height * gridSize.height);
                    [object setPosition:ccpAdd(object.position, offset)];
                }
            }
            
            [_mainTilemap addLayer:layer];
            layer.tilemap = _mainTilemap;
        }
    }
    
//    [self createMinmap];
}

- (void)createMinmap
{
    const int factor = 4;
    
    //add map bounds
    CGRect bounds = CGRectMake(_map.bounds.origin.x,
                               _map.bounds.origin.y,
                               _map.bounds.size.width * kCell_Width * factor,
                               _map.bounds.size.height * kCell_Height *factor);
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
        rect = CGRectMake(rect.origin.x * kCell_Width * factor + 2,
                          rect.origin.y * kCell_Height * factor + 2,
                          rect.size.width * kCell_Width * factor - 4,
                          rect.size.height * kCell_Height * factor - 4);
        
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
                    p = ccp(p.x * kCell_Width * factor, p.y * kCell_Height * factor - 1);
                    break;
                case kGDirctionSouth:
                    p = ccp(p.x + 0.5, p.y);
                    p = ccp(p.x * kCell_Width * factor, p.y * kCell_Height * factor + 1);
                    break;
                case kGDirctionWest:
                    p = ccp(p.x, p.y + 0.5);
                    p = ccp(p.x * kCell_Width * factor + 1, p.y * kCell_Height * factor);
                    break;
                case kGDirctionEast:
                    p = ccp(p.x + 1, p.y + 0.5);
                    p = ccp(p.x * kCell_Width * factor - 1, p.y * kCell_Height * factor);
                default:
                    break;
            }
            gateNode.position = p;
            [self addChild:gateNode];
        }
    }
}

- (CGRect)boundsFromMainLayerPosition:(CGPoint)position
{
    for (Room *room in _map.rooms) {
        CGRect cameraBounds = [self boundsByRoom:room];
        
        if (CGRectContainsPoint(cameraBounds, position)) {
            CGRect sceneFrame = self.kkScene.frame;;
            cameraBounds.origin.x = -cameraBounds.origin.x - cameraBounds.size.width + sceneFrame.origin.x + sceneFrame.size.width;
            cameraBounds.size.width = cameraBounds.size.width - sceneFrame.size.width;
            cameraBounds.origin.y = -cameraBounds.origin.y - cameraBounds.size.height + sceneFrame.origin.y + sceneFrame.size.height;
            cameraBounds.size.height = cameraBounds.size.height - sceneFrame.size.height;
            return cameraBounds;
        }
    }
    
    return CGRectZero;
}

-(CGRect) boundsByRoom:(Room *)room
{
	CGRect bounds = CGRectMake(INFINITY, INFINITY, INFINITY, INFINITY);
	bounds.origin.x = room.bounds.origin.x * kCell_Width * _gridSize.width;
    bounds.origin.y = room.bounds.origin.y * kCell_Height * _gridSize.height;
    bounds.size.width = room.bounds.size.width * kCell_Width * _gridSize.width;
    bounds.size.height = room.bounds.size.height * kCell_Height * _gridSize.height;
	return bounds;
}

@end
