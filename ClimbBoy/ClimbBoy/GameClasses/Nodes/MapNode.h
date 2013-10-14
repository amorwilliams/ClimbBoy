//
//  MapGenerator.h
//  ClimbBoy
//
//  Created by Robin on 13-10-6.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Map.h"

@interface MapNode : KKNode
{
    CGSize _gridSize;
    Map *_map;
}

@property (nonatomic, readonly) KKTilemap *mainTilemap;
@property (nonatomic) NSArray *roomNodes;

+ (id) MapWithGridSize:(CGSize)gridSize;

- (void) generate;
- (CGRect) boundsFromMainLayerPosition:(CGPoint)position;
@end
