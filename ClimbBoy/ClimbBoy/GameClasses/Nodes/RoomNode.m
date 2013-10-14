//
//  RoomNode.m
//  ClimbBoy
//
//  Created by Robin on 13-10-12.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "RoomNode.h"

@implementation RoomNode

+ (id)roomWithRoom:(Room *)room
{
    return [[[self class] alloc] initWithRoom:room];
}

- (id)initWithRoom:(Room *)room
{
    self = [super init];
    if (self) {
        _room = room;
        _tilemapNode = [KKTilemapNode tilemapWithContentsOfFile:[NSString stringWithFormat:@"%@.tmx",room.name]];
    }
    return self;
}

- (void)didMoveToParent
{
    [super didMoveToParent];
    
    [self addChild:_tilemapNode];
    
    SKNode *collisionsLayerPhysics = [_tilemapNode createPhysicsShapesWithObjectLayerNode:[_tilemapNode objectLayerNodeNamed:@"collisions"]];
    for (SKNode *node in collisionsLayerPhysics.children) {
        node.physicsBody.restitution = 0;
    }
    
    KKTilemapProperties *mapProperties = _tilemapNode.tilemap.properties;
    _gravity = CGVectorMake(0, [mapProperties numberForKey:@"physicsGravityY"].floatValue);
    
    [_tilemapNode spawnObjects];

    [_tilemapNode enableParallaxScrolling];
}

- (void)setEnable:(BOOL)enable
{
    if (_enable != enable) {
        if (enable) {
//            [_tilemapNode restrictScrollingToMapBoundary];
//            [_tilemapNode enableParallaxScrolling];
        }
        else {
//            [_tilemapNode removeAllBehaviors];
        }
        _enable = enable;
    }
}

@end
