//
//  KKTilemapNode+ClimbBoy.h
//  ClimbBoy
//
//  Created by Robin on 13-10-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKTilemapNode.h"

@interface KKTilemapNode (ClimbBoy)

+(id) tilemapWithContentsOfTilemap:(KKTilemap*)tilemap;

-(NSArray *) objectsLayerNodeNamed:(NSString*)name;

@end
