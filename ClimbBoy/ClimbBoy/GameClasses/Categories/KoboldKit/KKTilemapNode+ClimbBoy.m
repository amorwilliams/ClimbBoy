//
//  KKTilemapNode+ClimbBoy.m
//  ClimbBoy
//
//  Created by Robin on 13-10-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKTilemapNode+ClimbBoy.h"

@implementation KKTilemapNode (ClimbBoy)

+(id) tilemapWithContentsOfTilemap:(KKTilemap *)tilemap
{
	return [[[self class] alloc] initWithContentsOfTilemap:tilemap];
}

-(id) initWithContentsOfTilemap:(KKTilemap *)tilemap
{
	self = [super init];
	if (self)
	{
		_tilemap = tilemap;
		_tileLayerNodes = [NSMutableArray arrayWithCapacity:4];
		_objectLayerNodes = [NSMutableArray arrayWithCapacity:4];
	}
	return self;
}

- (NSArray *)objectsLayerNodeNamed:(NSString *)name
{
    NSMutableArray *objects = [NSMutableArray array];
    for (KKTilemapObjectLayerNode* objectLayerNode in _objectLayerNodes)
    {
        if ([objectLayerNode.name isEqualToString:name])
        {
            [objects addObject:objectLayerNode];
        }
    }
    
    return objects;
}

@end
